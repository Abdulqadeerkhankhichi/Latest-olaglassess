using Olaglasses.Models;
using Stripe;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    public class PaymentProcessController : Controller
    {
        OlaGlassesEntities dbEntity = new OlaGlassesEntities();

        [HttpGet]
        public ActionResult Index1(int? id = 0)
        {
            
            id = Convert.ToInt32(Session["UserID"]);
            return RedirectToAction("MovetoOrdercart", "Products", new { id = id });
        }

        [HttpPost]
        [Customexception]
        public ActionResult Index1(int? id = 0, double txtordertotal = 0, double txtdiscountamount = 0, double txtdiscountpercentage = 0, double txtsubtotal = 0)
        {

            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            List<tblAddress> order = dbEntity.tblAddress.Where(x => x.userID == id).OrderBy(a => a.BAddress).ToList();
            List<tblcart> cart = dbEntity.tblcart.Where(x => x.Userid == id).ToList();
            HttpCookie UserID = Request.Cookies["_UserID"];

            ViewBag.UserID = UserID.Value;


            double tax = txtsubtotal / 100 * 5;
            ViewBag.GrandAmount = txtordertotal;
            ViewBag.txtdiscountamount = txtdiscountamount;
            ViewBag.txtdiscountpercentage = txtdiscountpercentage;
            ViewBag.txtsubtotal = txtsubtotal;
            ViewBag.OrderList = order;
            ViewBag.tax = tax;
            ViewBag.cart = cart;
            tblcart tblcart;
            foreach (var item in cart)
            {
                tblcart = new tblcart();
                tblcart = dbEntity.tblcart.Find(item.Cartid);
                tblcart.GranTotal = txtordertotal;
                tblcart.Discount = txtdiscountpercentage;
                tblcart.Discountamount = txtdiscountamount;
                tblcart.TaxAmount = tax;

                dbEntity.Entry(tblcart).State = EntityState.Modified;
                dbEntity.SaveChanges();
            }

            if (order.Count()==0)
            {
                return RedirectToAction("Checkout", new { OlderID = 0 });
            }
            return View();
        }
        [Customexception]
        public ActionResult Checkout(int OlderID = 0)
        {

            int id = 0;
            id = Convert.ToInt32(Session["UserID"]);
            tblAddress order = new tblAddress();
            if (OlderID > 0)
            {
                order = dbEntity.tblAddress.Where(x => x.AddressID == OlderID && x.userID ==id).FirstOrDefault();
                if (order == null)
                {
                    order = dbEntity.tblAddress.Where(x => x.userID == id).FirstOrDefault();

                    if(order ==null)
                    {
                        OlderID = 0;
                    }
                }
            }


            List<tblcart> cart = dbEntity.tblcart.Where(x => x.Userid == id).ToList();
            //ViewBag.UserID = cart.FirstOrDefault().Userid;
            HttpCookie UserID = Request.Cookies["_UserID"];

            ViewBag.UserID = UserID.Value;
            ViewBag.GrandAmount = cart.FirstOrDefault().GranTotal;

            foreach (var item in cart)
            {
                ViewBag.txtdiscountamount = item.Discountamount;
                ViewBag.txtdiscountpercentage = item.Discount;
            }

            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            ViewBag.cart = cart;
            return View(order);
        }
        [HttpPost]
        [Customexception]
        public ActionResult Checkout(tblOrder order, string IsSame, int? id)
        {
            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            tblcart cart = dbEntity.tblcart.Where(x => x.Userid == id).FirstOrDefault();
            ViewBag.UserID = cart.Userid;
            ViewBag.GrandAmount = cart.GranTotal;
            var Emailsettings = dbEntity.tblSettings.FirstOrDefault();

            using (MailMessage mm = new MailMessage(Emailsettings.Email, order.BEmail))
            {
                string link = Request.Url.ToString();

                mm.Subject = "Thank you for order";

                string body = "Hello " + order.BFname + order.BLname + ",";
                body += "<br /><br />Thank you for placing order";
                body += "<br /><br />Your Order number is # " + order.OrderID + " ";
                mm.Body = body;
                mm.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = Emailsettings.SMTP;
                smtp.EnableSsl = Emailsettings.IsActive;
                NetworkCredential NetworkCred = new NetworkCredential(Emailsettings.Email, Emailsettings.Password);
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = Convert.ToInt32(Emailsettings.Port);
                smtp.Send(mm);
            }
            return View();
        }
        [HttpPost]
        [Obsolete]
        public ActionResult Index(string cardname, string cardNumber, string expirydate, string CVCNumber, int userID, List<tblAddress> orders, string IsSame, string amount = "")
        {

            try
            {
                tblOrder order = new tblOrder();
                foreach (var item in orders)
                {
                    order.BFname = item.BFname;
                    order.BLname = item.BLname;
                    order.BAddress = item.BAddress;
                    order.Bcity = item.Bcity;
                    order.BState = item.BState;
                    order.BPostalCode = item.BPostalCode;
                    order.BCountry = item.BCountry;
                    order.BEmail = item.BEmail;
                    order.BPhone = item.BPhone;

                }

                string s = "";
                string stripeexception = "";
                ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
                tblUser user = dbEntity.tblUsers.Find(userID);
                tblSetting sa = dbEntity.tblSettings.Find(3);
                DateTime date = Convert.ToDateTime(expirydate);
                int month = date.Month;
                int year = date.Year;
                try
                {
                    Stripe.StripeConfiguration.SetApiKey(sa.StripeID);
                    var options1 = new Stripe.TokenCreateOptions
                    {
                        Card = new Stripe.TokenCardOptions
                        {

                            Number = cardNumber,
                            ExpMonth = month,
                            ExpYear = year,
                            Cvc = CVCNumber,
                        },
                    };



                    Stripe.TokenService tokenService = new Stripe.TokenService();

                    Stripe.Token token = tokenService.Create(options1);

                    Stripe.CustomerCreateOptions customer = new Stripe.CustomerCreateOptions();

                    customer.Email = user.UserEmail;

                    customer.Source = token.Id;

                    var custService = new Stripe.CustomerService();

                    Stripe.Customer stpCustomer = custService.Create(customer);

                    double amounts = Convert.ToDouble(amount) * 100;

                    var options = new Stripe.ChargeCreateOptions
                    {

                        Amount = Convert.ToInt64(amounts),

                        Currency = "USD",

                        ReceiptEmail = sa.ReceipentEmail,

                        Customer = stpCustomer.Id,

                        Description = Convert.ToString("Payment to Ola Glasses"), //Optional  

                    };

                    //and Create Method of this object is doing the payment execution.  

                    var service = new Stripe.ChargeService();

                    Stripe.Charge charge = service.Create(options); // This will do the Payment

                    s = charge.Status;
                }
                catch (StripeException e)
                {
                    ViewBag.stripeexception = e.StripeError.Message;
                    switch (e.StripeError.Type)
                    {

                        case "card_error":
                            Console.WriteLine("Code: " + e.StripeError.Code);
                            Console.WriteLine("Message: " + e.StripeError.Message);

                            break;
                        case "api_connection_error":
                            break;
                        case "api_error":
                            break;
                        case "authentication_error":
                            break;
                        case "invalid_request_error":
                            break;
                        case "rate_limit_error":
                            break;
                        case "validation_error":
                            break;
                        default:
                            // Unknown Error Type
                            break;
                    }

                    return Json(new { status = "0", error = ViewBag.stripeexception });
                    //return View();
                }



                if (s != "succeeded")
                {
                    ViewBag.message = "There is a problem in transaction please retry.";
                    return Json(new { status = "-1", error = "There is a problem in transaction please retry." });
                }

                else
                {
                    tblAddress address = new tblAddress();
                    tblUserPrescription userPrescription;
                    tblOrderDetails orderDetails;
                    tblOrderPrescription orderPrescription;
                    tblOrder tblOrder = new tblOrder();
                    tblOrder = order;
                    tblOrder.userID = userID;
                    tblOrder.OrderDate = DateTime.Now;
                    tblOrder.UserName = user.Firstname + " " + user.Lastname;
                    tblOrder.UserEmail = user.UserEmail;
                    tblOrder.Status = "Not Started";
                    tblOrder.Total = Convert.ToDecimal(amount);
                    tblOrder.UserAddress = user.Address;
                    
                    if (IsSame == "on")
                    {
                        tblOrder.SFname = order.BFname;
                        tblOrder.SLname = order.BLname;
                        tblOrder.SAddress = order.BAddress;
                        tblOrder.Scity = order.Bcity;
                        tblOrder.SState = order.BState;
                        tblOrder.SPostalCode = order.BPostalCode;
                        tblOrder.SCountry = order.BCountry;
                        tblOrder.SEmail = order.BEmail;
                        tblOrder.SPhone = order.BPhone;


                    }
                   
                    List<tblcart> cart = dbEntity.tblcart.Where(x => x.Userid == userID).ToList();

                    foreach (var item in cart)
                    {
                        tblOrder.CouponID = item.CouponID;
                        tblOrder.CouponCode = item.CouponCode;
                        tblOrder.Discountpercentage = item.Discount;
                        tblOrder.Discountamount = item.Discountamount;
                    }

                    dbEntity.tblOrder.Add(tblOrder);
                    dbEntity.SaveChanges();

                    address.userID = userID;
                    address.BFname = order.BFname;
                    address.BLname = order.BLname;
                    address.BAddress = order.BAddress;
                    address.Bcity = order.Bcity;
                    address.BState = order.BState;
                    address.BPostalCode = order.BPostalCode;
                    address.BCountry = order.BCountry;
                    address.BEmail = order.BEmail;
                    address.BPhone = order.BPhone;
                    if (IsSame == "on")
                    {
                        
                        address.SFname = order.BFname;
                        address.SLname = order.BLname;
                        address.SAddress = order.BAddress;
                        address.Scity = order.Bcity;
                        address.SState = order.BState;
                        address.SPostalCode = order.BPostalCode;
                        address.SCountry = order.BCountry;
                        address.SEmail = order.BEmail;
                        address.SPhone = order.BPhone;

                    }
                    dbEntity.tblAddress.Add(address);
                    dbEntity.SaveChanges();
                    int orderID = tblOrder.OrderID;



                    foreach (var item in cart)
                    {
                        double subTotal = 0;
                        orderDetails = new tblOrderDetails();
                        orderDetails.OrderID = orderID;
                        orderDetails.ProductID = item.GlassID;
                        orderDetails.Productname = item.Title;
                        orderDetails.ProductPrice = item.Price.ToString();
                        orderDetails.OrderDate = DateTime.Now;
                        orderDetails.Vision = item.VisionType;
                        orderDetails.LensType = item.LensType;
                        orderDetails.UV_Protection = item.UVProtection;
                        orderDetails.Total = item.TotalAmount.ToString();
                        orderDetails.ProductVariation = item.Variationid;
                        orderDetails.quantity = item.Quantity;
                        orderDetails.TaxAmount = item.TaxAmount;
                        orderDetails.Discount = item.Discount;
                        orderDetails.FrameColor = item.Colour;
                        orderDetails.ProductImage = item.ProductImagePath;
                        orderDetails.ShippingAmount = item.Shippingamount;
                        subTotal = item.TotalAmount;
                        //if (item.LensType == "Standard")
                        //{
                        //    subTotal = subTotal + 39;
                        //}
                        //else if (item.LensType == "Enhanced")
                        //{
                        //    subTotal = subTotal + 49;
                        //}
                        //if (item.UVProtection == "on")
                        //{
                        //    subTotal = subTotal + 20;
                        //}
                        orderDetails.Subtotal = subTotal;

                        dbEntity.tblOrderDetails.Add(orderDetails);
                        dbEntity.SaveChanges();

                        if (item.VisionType.Trim() != "" && item.VisionType != null)
                        {
                            orderPrescription = new tblOrderPrescription();
                            orderPrescription.ProductID = item.GlassID;
                            orderPrescription.OrderID = orderID;
                            orderPrescription.r_sph = item.r_sph;
                            orderPrescription.r_cyl = item.r_cyl;
                            orderPrescription.r_axis = item.r_axis;
                            orderPrescription.r_add = item.r_add;
                            orderPrescription.l_sph = item.l_sph;
                            orderPrescription.l_cyl = item.l_cyl;
                            orderPrescription.l_axis = item.l_axis;
                            orderPrescription.l_add = item.l_add;
                            orderPrescription.lensType = item.VisionType;
                            orderPrescription.quantity = item.Quantity;
                            orderPrescription.Fname = item.Fname;
                            orderPrescription.Lname = item.Lname;
                            orderPrescription.prescription = item.prescription;
                            orderPrescription.prescriptionDate = item.prescriptionDate;
                            orderPrescription.PD = item.PD;
                            orderPrescription.UserID = item.Userid;
                            orderPrescription.PDImage = item.PDImage;
                            orderPrescription.PrescriptionImage = item.PrescriptionImage;
                            dbEntity.tblOrderPrescription.Add(orderPrescription);
                            dbEntity.SaveChanges();
                            if (item.prescription == "Yes")
                            {
                                userPrescription = new tblUserPrescription();
                                userPrescription.ProductID = item.GlassID;
                                userPrescription.OrderID = orderID;
                                userPrescription.r_sph = item.r_sph;
                                userPrescription.r_cyl = item.r_cyl;
                                userPrescription.r_axis = item.r_axis;
                                userPrescription.r_add = item.r_add;
                                userPrescription.l_sph = item.l_sph;
                                userPrescription.l_cyl = item.l_cyl;
                                userPrescription.l_axis = item.l_axis;
                                userPrescription.l_add = item.l_add;
                                userPrescription.lensType = item.VisionType;
                                userPrescription.quantity = item.Quantity;
                                userPrescription.Fname = item.Fname;
                                userPrescription.Lname = item.Lname;
                                userPrescription.prescription = item.prescription;
                                userPrescription.prescriptionDate = item.prescriptionDate;
                                userPrescription.PD = item.PD;
                                userPrescription.UserID = item.Userid;
                                userPrescription.PDImage = item.PDImage;
                                userPrescription.PrescriptionImage = item.PrescriptionImage;
                                userPrescription.Dualpd = item.Dualpd;
                                userPrescription.Rightpd = item.Rightpd;
                                userPrescription.Segmentheight = item.Segmentheight;
                                dbEntity.tblUserPrescription.Add(userPrescription);
                                dbEntity.SaveChanges();
                            }
                        }
                    }

                    var usercart = dbEntity.tblcart.Where(a => a.Userid == userID);
                    dbEntity.tblcart.RemoveRange(usercart);
                    dbEntity.SaveChanges();

                    string baseUrl = Request.Url.Scheme + "://" + Request.Url.Authority + Request.ApplicationPath.TrimEnd('/') + "/";
                    var Emailsettings = dbEntity.tblSettings.FirstOrDefault();

                    //using (MailMessage mm = new MailMessage(Emailsettings.Email, order.BEmail))
                    //{
                    //    string link = Request.Url.ToString();

                    //    mm.Subject = "Thank you for order";

                    //    string body = "";
                    //    body += "<body  style='background-color:white !important'>";
                    //    body += "<div class='Container' > <div class='row' style='padding:20px !important'> <div class='col-md-6' marginheight='0' topmargin='0' marginwidth='0'  leftmargin='0'> ";
                    //    body += " <table style='padding:20px !important;background-color: #f2f3f8; max-width:670px;  margin:150 auto;' width='100%' border='0' align='center' cellpadding='0' cellspacing='0'>";
                    //    body += " <tr > <td>";
                    //    body += " <table width='95%' border='0' align='center' cellpadding='0' cellspacing='0' style='max-width:670px; background:#f2f3f8; border-radius:3px; text-align:center;-webkit-box-shadow:0' ";

                    //    body += "<tr><td style='padding: 0 35px; '><a href='#' title='Reset Password' target='_blank'><img width='60% !important' src='https://optical.yehtohoga.com/assets/img/Logo.png' title='logo' alt='logo'></a>";
                    //    body += "<h1 style='color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;'>Thank you for order</h1>";
                    //    body += "<span style='display: inline-block; vertical-align:middle;  border-bottom:1px solid #cecece; width:100px;'></span>";
                    //    body += "<h3> Hi " + order.BFname + order.BLname + "</h3>";
                    //    body += "<p style='color:#455056; font-size:15px;line-height:24px; margin:0;'>Click on the button to view your order details.</p>";

                    //    body += "<a href='" + baseUrl + "PaymentProcess/OrderDetailsView/" + order.OrderID + "' style='background:#009B95;text-decoration:none !important; font-weight:500; margin-top:35px; color:#fff;text-transform:uppercase;font-size:14px;padding:10px 24px;display:inline-block;'> View Order</a> ";
                    //    body += "<p >If you have any questions please email us on  <a style='cursor:pointer;text-decoration: underline;color:#0d6efd'> info@olaglasses.com</a>  </p>";
                    //    body += "<p > Mahalo,  </p> ";
                    //    body += "<p >Ola Glasses Team </p>";
                    //    body += "</td> </tr>  <tr>  <td style='height: 40px; '>&nbsp;</td>  </tr> </table> </td>    </table>";
                    //    body += "</div> </div> </div> </body>";
                    //    mm.Body = body;
                    //    mm.IsBodyHtml = true;
                    //    SmtpClient smtp = new SmtpClient();
                    //    smtp.Host = Emailsettings.SMTP;
                    //    smtp.EnableSsl = Emailsettings.IsActive;
                    //    NetworkCredential NetworkCred = new NetworkCredential(Emailsettings.Email, Emailsettings.Password);
                    //    smtp.UseDefaultCredentials = true;
                    //    smtp.Credentials = NetworkCred;
                    //    smtp.Port = Convert.ToInt32(Emailsettings.Port);
                    //    smtp.Send(mm);
                    //}


                    //start Get Response from UPS Shipment API


                    //End Get Response from UPS Shipment API


                    return Json(new { status = "1", url = Url.Action("OrderDetails", "PaymentProcess", new { id = orderID }) });
                    //return RedirectToAction("OrderDetails", "PaymentProcess", new { id = orderID });
                }

            }
            catch (Exception ex)
            {
                //ViewBag.message = "There is a problem in transaction please retry.";

                return Json(new { status = "Exception", error = ex.Message });
                throw;
            }

        }

        [Customexception]
        public ActionResult OrderDetails(int? id = 1)
        {
            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            List<spgetorderDetails_Result1> spgetorderDetails = dbEntity.spgetorderDetails(id).ToList();
            ViewBag.OrderDetails = spgetorderDetails;
            return View();
        }
        [Customexception]
        public ActionResult OrderDetailsView(int? id = 1)
        {
            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            List<spgetorderDetails_Result1> spgetorderDetails = dbEntity.spgetorderDetails(id).ToList();
            ViewBag.OrderDetails = spgetorderDetails;
            return View();

        }
    }
}