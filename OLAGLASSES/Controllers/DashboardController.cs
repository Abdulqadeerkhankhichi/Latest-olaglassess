using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    [FilterConfig.NoDirectAccess]
    [FilterConfig.AuthorizeActionFilter]
    public class DashboardController : Controller
    {
        OlaGlassesEntities dbEntity = new OlaGlassesEntities();
        [Customexception]
        public ActionResult Index()
        {

            ViewBag.users = dbEntity.tblUsers.Count();
            ViewBag.TotalOrder = dbEntity.tblOrder.Count();
            ViewBag.Pending = dbEntity.tblOrder.Where(x=>x.Status== "InProgress").Count();
            ViewBag.NotStarted = dbEntity.tblOrder.Where(x => x.Status == "Not Started").Count();
            ViewBag.Complete = dbEntity.tblOrder.Where(x => x.Status == "Complete").Count();
            ViewBag.Delivered = dbEntity.tblOrder.Where(x => x.Status == "Delivered").Count();
            ViewBag.Remake = dbEntity.tblOrder.Where(x => x.Status == "Remake").Count();
            ViewBag.Subscription = dbEntity.tblEmailSubscribe.Count();
            return View();
        }
        [Customexception]
        public ActionResult Users(string message)
        {
            ViewBag.message = message;
            List<tblUser> users = new List<tblUser>();
            users = dbEntity.tblUsers.ToList();
            ViewBag.usersList = users;
            return View();
        }

        [Customexception]
        public ActionResult UsersEdit(int? id, string message)
        {
            ViewBag.message = message;
            tblUser user = new tblUser();
            if (id == 0)
            {
                var path = "/ProjectImages/UserImages/user.jpg";
                user.UserEmail = "";
                user.Address = "";
                user.Phone = "";
                user.Firstname = "";
                user.Lastname = "";
                user.UserImage = path;
                user.Gender = "";
                user.UserID = 0;
            }
            else
            {

                user = dbEntity.tblUsers.Find(id);
                if (user.UserImage == null)
                {
                    var path = "/ProjectImages/UserImages/user.jpg";
                    user.UserImage = path;
                }

            }
            return View(user);
        }


        [HttpPost]
        [Customexception]
        public ActionResult UsersEdit(tblUser user, HttpPostedFileBase Image)
        {
            if (Image != null)
            {
                var ext = Path.GetExtension(Image.FileName);
                string myfile = user.Firstname + "_" + user.UserID + ext;
                var path = Path.Combine(Server.MapPath("~/ProjectImages/UserImages"), myfile);
                var path1 = Path.Combine(("\\ProjectImages\\UserImages"), myfile);
                user.UserImage = path1;
                Image.SaveAs(path);
            }
            else
            {
                var path = "/ProjectImages/UserImages/user.jpg";
                user.UserImage = path;
            }
            if (user.UserID > 0) {

               
                using (var context = new OlaGlassesEntities())
                {
                    user.UserStatus = 1;
                    user.CreatedDate = DateTime.Now;
                    context.Entry(user).State = EntityState.Modified;
                    context.SaveChanges();
                }
                return RedirectToAction("Users", new { message = "Record Updated Successfully" });
            }
            else
            {
                dbEntity.tblUsers.Add(user);
                dbEntity.SaveChanges();
                return RedirectToAction("Users", new { message = "Record Added Successfully" });
            }
           
           
           


        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Customexception]
        public ActionResult DeleteUsers(int? id)
        {
            try
            {

                tblUser make = dbEntity.tblUsers.Find(id);
                if (make != null)
                {
                    dbEntity.tblUsers.Remove(make);
                    dbEntity.SaveChanges();
                }


                return RedirectToAction("Users", new { message = "Record Deleted Successfully" });
            }
            catch (Exception)
            {

                throw;
            }

        }
        [Customexception]
        public ActionResult OrderDetails(int? id = 1)
        {
            List<spgetorderDetails_Result3> spgetorderDetails = dbEntity.spgetorderDetails(id).ToList();
            ViewBag.OrderDetails = spgetorderDetails;
            return View();

        }

        [HttpPost]

        public ActionResult Orderstatusupdate(int? id, int? userid, string ostatus = "", string status = "", int emailtype = 0)
        {


            if (emailtype == 0)
            {
                tblOrder od = dbEntity.tblOrder.Where(o => o.OrderID == id).FirstOrDefault();
                od.Status = ostatus;
                dbEntity.SaveChanges();



            }
            else if (emailtype == 1)

            {
                var Emailsettings = dbEntity.tblSettings.FirstOrDefault();
                tblOrder od = dbEntity.tblOrder.Where(o => o.OrderID == id).FirstOrDefault();
                using (MailMessage mm = new MailMessage(Emailsettings.Email, od.BEmail))
                {
                    string link = Request.Url.ToString();

                    mm.Subject = "Order Status Update";

                    //string body = "Hi " + od.BFname + ",";
                    //body += "<br /><br />Your order# " + id + " is now at  " + od.Status + " status";
                    //body += "<br /><br />If you have any questions please email us on  <a style='cursor:pointer;text-decoration: underline;color:#0d6efd'> info@olaglasses.com</a> ";
                    //body += "<br /><br />Mahalo,  ";
                    //body += "<br /><br />Ola Glasses Team";

                    string body = "";
                    body += "<body  style='background-color:white !important'>";
                    body += "<div class='Container' > <div class='row' style='padding:20px !important'> <div class='col-md-6' marginheight='0' topmargin='0' marginwidth='0'  leftmargin='0'> ";
                    body += " <table style='padding:20px !important;background-color: #f2f3f8; max-width:670px;  margin:150 auto;' width='100%' border='0' align='center' cellpadding='0' cellspacing='0'>";
                    body += " <tr > <td>";
                    body += " <table width='95%' border='0' align='center' cellpadding='0' cellspacing='0' style='max-width:670px; background:#f2f3f8; border-radius:3px; text-align:center;-webkit-box-shadow:0' ";

                    body += "<tr><td style='padding: 0 35px; '><a href='#' title='Order Status Update' target='_blank'><img width='60% !important' src='https://optical.yehtohoga.com/assets/img/Logo.png' title='logo' alt='logo'></a>";
                    body += "<h1 style='color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;'>Order Status Update</h1>";
                    body += "<h3> Hi " + od.BFname + "</h3>";

                    body += "<a  style='background:#009B95;text-decoration:none !important; font-weight:500;color:#fff;text-transform:uppercase;font-size:14px;padding:10px 24px;display:inline-block;'> Your order# " + id + " is now at  " + od.Status + " status</a> ";
                    body += "<p >If you have any questions please email us on  <a style='cursor:pointer;text-decoration: underline;color:#0d6efd'> info@olaglasses.com</a>  </p>";
                    body += "<p > Mahalo,  </p> ";
                    body += "<p >Ola Glasses Team </p>";
                    body += "</td> </tr>  <tr>  <td style='height: 40px; '>&nbsp;</td>  </tr> </table> </td>    </table>";
                    body += "</div> </div> </div> </body>";
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
            }




            return Json(new { url = Url.Action("Orders", "Dashboard", new { id = userid, status = status }) });
        }
        [Customexception]
        public ActionResult Orders(int? id, string status = "All")
        {
            ViewBag.userid = id;
            List<string> OrderStatus = new List<string>();
            OrderStatus.Add("Not Started");
            OrderStatus.Add("InProgress");
            OrderStatus.Add("Complete");
            OrderStatus.Add("Delivered");
            OrderStatus.Add("Remake");
            ViewBag.OrderStats = OrderStatus.ToList();
            ViewBag.Type = status;
            List<tblOrder> orders = new List<tblOrder>();
            if (id == 1)
            {
                if (status != "All")
                {
                    orders = dbEntity.tblOrder.Where(x => x.Status == status).OrderByDescending(x => x.OrderID).ToList();
                }
                else
                {
                    orders = dbEntity.tblOrder.OrderByDescending(x => x.OrderID).OrderByDescending(x => x.OrderID).ToList();
                }
            }
            else
            {
                if (status != "All")
                {
                    orders = dbEntity.tblOrder.Where(x => x.userID == id && x.Status == status).OrderByDescending(x => x.OrderID).ToList();
                }
                else
                {
                    orders = dbEntity.tblOrder.Where(x => x.userID == id).OrderByDescending(x => x.OrderID).ToList();
                }
            }
            ViewBag.ordersList = orders;
            ViewBag.UserID = id;
            return View();
        }
        [Customexception]
        public ActionResult ChangePassword()
        {
            return View();
        }
        [Customexception]
        public ActionResult PersonalInfo(int? id, string Ismessage)
        {
            ViewBag.IsError = Ismessage;
            tblUser user = new tblUser();
            if (id == 0)
            {
                var path = "/ProjectImages/UserImages/user.jpg";
                user.UserEmail = "";
                user.Address = "";
                user.Phone = "";
                user.Firstname = "";
                user.Lastname = "";
                user.UserImage = path;
                user.Gender = "";

            }
            else
            {

                user = dbEntity.tblUsers.Find(id);
                if (user.UserImage == null)
                {
                    var path = "/ProjectImages/UserImages/user.jpg";
                    user.UserImage = path;
                }

            }
            return View(user);
        }

        [HttpPost]
        [Customexception]
        public ActionResult PersonalInfo(tblUser user, HttpPostedFileBase Image)
        {
            var allowedExtensions = new[] { ".Jpg", ".png", ".jpg", ".jpeg" };

            if (Image != null)
            {
                var ext = Path.GetExtension(Image.FileName);
                string myfile = user.Firstname + "_" + user.UserID + ext;
                var path = Path.Combine(Server.MapPath("~/ProjectImages/UserImages"), myfile);
                var path1 = Path.Combine(("\\ProjectImages\\UserImages"), myfile);
                user.UserImage = path1;
                Image.SaveAs(path);
            }
            using (var context = new OlaGlassesEntities())
            {
                user.UserStatus = 1;
                user.CreatedDate = DateTime.Now;
                context.Entry(user).State = EntityState.Modified;
                context.SaveChanges();
            }
            Session["UserImage"] = user.UserImage;
            Session["userName"] = user.Firstname + " " + user.Lastname;
            HttpCookie Namecookie = Request.Cookies["_UserName"];
            HttpCookie Imagecookie = Request.Cookies["_UserImage"];

            //Name Cookie

            if (Namecookie == null)
            {
                Namecookie = new HttpCookie("_UserName");
                Namecookie.Value = Convert.ToString(user.Firstname + " " + user.Lastname);
                Namecookie.Expires = DateTime.Now.AddDays(30);
            }
            else
            {
                Namecookie.Value = Convert.ToString(user.Firstname + " " + user.Lastname);
            }
            Response.Cookies.Add(Namecookie);

            //Image Cookie

            if (Imagecookie == null)
            {
                Imagecookie = new HttpCookie("_UserImage");
                if (user.UserImage == null)
                {
                    Imagecookie.Value = "/ProjectImages/UserImages/user.jpg";
                }
                else
                {
                    Imagecookie.Value = user.UserImage;
                }

                Imagecookie.Expires = DateTime.Now.AddDays(30);
            }
            else
            {
                Imagecookie.Value = user.UserImage;
            }
            Response.Cookies.Add(Imagecookie);



            ViewBag.IsError = "User Updated Successfully";
            return RedirectToAction("PersonalInfo", new { id = user.UserID, Ismessage = "Personal Info Updated Successfully" });
        }
        [HttpPost]
        [Customexception]
        public ActionResult ChangePassword(string oldPassword, string newPassword)
        {
            try
            {
                string encryptedpassword = Encrypt(oldPassword, "sblw-3hn8-sqoy19");
                string Email = Session["Email"].ToString();
                HttpCookie _UserEmail = Request.Cookies["_UserEmail"];
                if (Email == null)
                {
                    Email = _UserEmail.Value;
                }


                tblUser User = dbEntity.tblUsers.Where(x => x.UserPass == encryptedpassword && x.UserEmail == Email).FirstOrDefault();
                if (User == null)
                {
                    ViewBag.IsError = "Your old Password is incorrect.";
                    return View();
                }
                else
                {
                    string encryptedpassword1 = Encrypt(newPassword, "sblw-3hn8-sqoy19");
                    User.UserPass = encryptedpassword1;
                    dbEntity.Entry(User).State = EntityState.Modified;
                    dbEntity.SaveChanges();
                    ViewBag.IsSuccess = "Password change successfully.";
                    return View();
                }
            }
            catch (Exception)
            {

                throw;
            }

        }
        public static string Encrypt(string input, string key)
        {
            byte[] resultArray = { };
            try
            {
                byte[] inputArray = UTF8Encoding.UTF8.GetBytes(input);
                TripleDESCryptoServiceProvider tripleDES = new TripleDESCryptoServiceProvider();
                tripleDES.Key = UTF8Encoding.UTF8.GetBytes(key);
                tripleDES.Mode = CipherMode.ECB;
                tripleDES.Padding = PaddingMode.PKCS7;
                ICryptoTransform cTransform = tripleDES.CreateEncryptor();
                resultArray = cTransform.TransformFinalBlock(inputArray, 0, inputArray.Length);
                tripleDES.Clear();
                return Convert.ToBase64String(resultArray, 0, resultArray.Length);
            }
            catch (Exception ex)
            {

            }
            return Convert.ToBase64String(resultArray, 0, resultArray.Length);

        }

        [Customexception]
        public ActionResult Favourites(int? id)
        {
            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            List<Sp_Get_Favourite_List_Result> favourites = dbEntity.Sp_Get_Favourite_List(id).ToList();
            ViewBag.favouritesList = favourites;
            ViewBag.UserID = id;
            return View();
        }
        [Customexception]
        public ActionResult Unfavourite(int? id, int userID)
        {
            dbEntity.Database.ExecuteSqlCommand("Delete from tblFavourite where FavouriteID=" + id);
            dbEntity.SaveChanges();
            return RedirectToAction("Favourites", new { id = userID });
        }


        [Customexception]
        public ActionResult EmailSubscriptions()
        {

            List<tblEmailSubscribe> emailSubscribes = dbEntity.tblEmailSubscribe.ToList();
            ViewBag.emailSubscribes = emailSubscribes;
            return View();


        }
    }
}