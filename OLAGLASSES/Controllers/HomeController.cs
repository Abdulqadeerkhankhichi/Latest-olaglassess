using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    public class HomeController : Controller
    {
        OlaGlassesEntities dbEntity = new OlaGlassesEntities();



        //[HttpPost]
        //public ActionResult CarrierDocumentUpload(tblcart cartdata, int? isusedsaveprescription = 0,string imageData="")
        //{


        //    //Convert Base64 string to Byte Array.
        //    byte[] bytes = Convert.FromBase64String(imageData);

        //    //Save the Byte Array as Image File.
        //    string filePath = string.Format("~/Files/{0}.png", Path.GetRandomFileName());



        //    System.IO.File.WriteAllBytes(Server.MapPath(filePath), bytes);

        //    string MainRoot = "";
        //    if (Request.Files.Count > 0)
        //    {

        //        try
        //        {
        //            // Get all files from Request object
        //            HttpFileCollectionBase files = Request.Files;
        //            for (int i = 0; i < files.Count; i++)
        //            {
        //                //string path = AppDomain.CurrentDomain.BaseDirectory + “Uploads/”;
        //                //string filename = Path.GetFileName(Request.Files[i].FileName);
        //                HttpPostedFileBase file = files[i];
        //                string fname;
        //                // Checking for Internet Explorer
        //                if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
        //                {
        //                    string[] testfiles = file.FileName.Split(new char[] { '\\' });
        //                    fname = testfiles[testfiles.Length - 1];
        //                    fname = file.FileName;
        //                }
        //                else
        //                {
        //                    fname = file.FileName;

        //                }

        //                var MCAuthorityFileName = Path.GetFileName(file.FileName);
        //                MainRoot = "/Uploads/Carrier/";

        //                bool exists = System.IO.Directory.Exists(Server.MapPath(MainRoot));
        //                if (!exists)
        //                    System.IO.Directory.CreateDirectory(Server.MapPath(MainRoot));



        //                var MCAuhtorityServerFilePath = Path.Combine(Server.MapPath(MainRoot) + "\\" + MCAuthorityFileName);

        //                MainRoot = "/Uploads/Carrier/"  + MCAuthorityFileName;

        //                //Save Files to path
        //                file.SaveAs(MCAuhtorityServerFilePath);



        //            }
        //            // Returns message that successfully uploaded
        //            return Json("File Uploaded Successfully!");
        //        }
        //        catch (Exception ex)
        //        {

        //        }


        //    }
        //    return Json("File Uploaded Successfully!");
        //}
        [Customexception]
        public ActionResult termscondition()
        {

            return View();
        }
        [Customexception]
        public ActionResult ProductFavourite(int? id = 0, string type = "")
        {
            try
            {
                int UserID = 0;

                HttpCookie _UserID = Request.Cookies["_UserID"];
                if (_UserID.Value != null & _UserID.Value != "")
                {
                    UserID = Convert.ToInt32(_UserID.Value);
                    Session["UserID"] = Convert.ToInt32(_UserID.Value);
                }
                else
                {
                    UserID = Convert.ToInt32(Session["UserID"]);
                }

                if (UserID != 0)
                {
                    var ReviewLikeExist = dbEntity.tblFavourites.Where(a => a.ProductID == id && a.UserID == UserID);

                    if (ReviewLikeExist.Count() > 0)
                    {
                        var ReviewLike = dbEntity.tblFavourites.Where(a => a.ProductID == id && a.UserID == UserID);
                        dbEntity.tblFavourites.RemoveRange(ReviewLike);
                        dbEntity.SaveChanges();
                    }
                    else
                    {
                        tblFavourite tbl = new tblFavourite();
                        tbl.UserID = UserID;
                        tbl.ProductID = id;
                        tbl.CreateDate = DateTime.Now;
                        dbEntity.tblFavourites.Add(tbl);
                        dbEntity.SaveChanges();

                    }

                }
                if (type == "A")
                    return RedirectToAction("Accessories", "Home");
                if (type == "E")
                    return RedirectToAction("eyeglassess", "Home");
                if (type == "S")
                    return RedirectToAction("Sunglassess", "Home");
                if (type == "H")
                    return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {

            }
            return RedirectToAction("Product_Details", "Products", new { Productid = id });
        }

        [Customexception]
        public ActionResult index(string sticker="")
        {
            try
            {
                tblpromotionoffer promotion = dbEntity.tblpromotionoffer.Where(x => x.isActive == 1).FirstOrDefault();
                HttpCookie _promotionColor = Request.Cookies["_promotionColor"];
                HttpCookie _promotionText = Request.Cookies["_promotionText"];

                if (promotion != null)
                {
                    if (_promotionColor == null)
                    {
                        _promotionColor = new HttpCookie("_promotionColor");
                        _promotionColor.Value = Convert.ToString(promotion.colorcode);
                        _promotionColor.Expires = DateTime.Now.AddDays(30);
                    }
                    else
                    {
                        _promotionColor.Value = Convert.ToString(promotion.colorcode);
                    }

                    Response.Cookies.Add(_promotionColor);

                    if (_promotionText == null)
                    {
                        _promotionText = new HttpCookie("_promotionText");
                        _promotionText.Value = Convert.ToString(promotion.description);
                        _promotionText.Expires = DateTime.Now.AddDays(30);
                    }
                    else
                    {
                        _promotionText.Value = Convert.ToString(promotion.description);
                    }
                    Response.Cookies.Add(_promotionText);



                }
                else
                {
                    _promotionColor = new HttpCookie("_promotionColor");
                    _promotionColor.Value = "";
                    _promotionColor.Expires = DateTime.Now.AddDays(30);
                    Response.Cookies.Add(_promotionColor);

                    _promotionText = new HttpCookie("_promotionText");
                    _promotionText.Value = "";
                    _promotionText.Expires = DateTime.Now.AddDays(30);
                    Response.Cookies.Add(_promotionText);


                }

                //check if User Login info exists in  Cookie
                HttpCookie usercookie = Request.Cookies["_UserEmail"];
                if (usercookie == null)
                {
                    usercookie = new HttpCookie("_UserEmail");
                    usercookie.Value = "";
                    usercookie.Expires = DateTime.Now.AddDays(30);
                }
                Response.Cookies.Add(usercookie);

                HttpCookie _UserID = Request.Cookies["_UserID"];
                if (_UserID == null)
                {
                    _UserID = new HttpCookie("_UserID");
                    _UserID.Value = "";
                    _UserID.Expires = DateTime.Now.AddDays(30);
                }
                Response.Cookies.Add(_UserID);

                HttpCookie _UserName = Request.Cookies["_UserName"];
                if (_UserName == null)
                {
                    _UserName = new HttpCookie("_UserName");
                    _UserName.Value = "";
                    _UserName.Expires = DateTime.Now.AddDays(30);
                }
                Response.Cookies.Add(_UserName);

                HttpCookie _UserImage = Request.Cookies["_UserImage"];
                if (_UserImage == null)
                {
                    _UserImage = new HttpCookie("_UserImage");
                    _UserImage.Value = "";
                    _UserImage.Expires = DateTime.Now.AddDays(30);
                }
                Response.Cookies.Add(_UserImage);

                HttpCookie _UserRole = Request.Cookies["_UserRole"];
                if (_UserRole == null)
                {
                    _UserRole = new HttpCookie("_UserRole");
                    _UserRole.Value = "";
                    _UserRole.Expires = DateTime.Now.AddDays(30);
                }
                Response.Cookies.Add(_UserRole);


                //Session["Coupon"] = dbEntity.tblCoupons.Where(x => x.CouponStatus == "Active").FirstOrDefault();
                //Replace session user here 
                int Userid = 0;
                Userid = Convert.ToInt32(Session["UserID"]);
                ViewBag.ProductList = dbEntity.Sp_Get_Product_List(Userid, sticker).ToList();
                ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
                ViewBag.ClientReviews = dbEntity.Sp_Get_Five_Reviews().ToList();



                //Dropdown List Values
                List<string> Gender = new List<string>();
                Gender.Add("Men");
                Gender.Add("Women");
                Gender.Add("Trans");
                ViewBag.Genderlist = Gender.ToList();

                List<string> AvailableSize = new List<string>();
                AvailableSize.Add("Medium");
                AvailableSize.Add("Large");
                AvailableSize.Add("Small");
                ViewBag.AvailableSize = AvailableSize.ToList();

                List<string> Material = new List<string>();
                Material.Add("Titanium");
                Material.Add("Plastic");
                Material.Add("Plastic Metal");
                ViewBag.Material = Material.ToList();

                List<string> shape = new List<string>();
                shape.Add("Round");
                shape.Add("Square");
                shape.Add("Aviator");
                shape.Add("Polygon");
                shape.Add("Cat Eye");
                ViewBag.shape = shape.ToList();

                List<tblColors> colour = new List<tblColors>();
                colour = dbEntity.tblColors.ToList();
                ViewBag.colour = colour;


               
                //UPS API INTEGRATION 



            }
            catch (Exception ex)
            {

            }
            return View();
        }
        [Customexception]
        public ActionResult newsdetail(int? id = 0)
        {

            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            try
            {

            }
            catch (Exception ex)

            {

            }

            return View();
        }


        [Customexception]
        public ActionResult About()
        {

            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            try
            {

            }
            catch (Exception ex)

            {

            }

            return View();
        }
        [Customexception]
        public ActionResult eyeglassess(string[] ddlgender, string[] ddlMaterial, string[] ddlAvailableSize, string[] ddlshape)
        {
            string cwhere = "";
            var genderfilters = "";
            var materialfilters = "";
            var availablesizesfilters = "";
            var shapesfilters = "";
            int Userid = 0;
            HttpCookie _UserID = Request.Cookies["_UserID"];
            if (_UserID.Value != null & _UserID.Value != "")
            {
                Userid = Convert.ToInt32(_UserID.Value);
                Session["UserID"] = Convert.ToInt32(_UserID.Value);
            }
            else
            {
                Userid = Convert.ToInt32(Session["UserID"]);
            }

            try
            {
                ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
                //Dropdown List Values
                List<string> Gender = new List<string>();
                Gender.Add("Men");
                Gender.Add("Women");
                Gender.Add("Trans");
                ViewBag.Genderlist = Gender.ToList();

                List<string> AvailableSize = new List<string>();
                AvailableSize.Add("Medium");
                AvailableSize.Add("Large");
                AvailableSize.Add("Small");
                ViewBag.AvailableSize = AvailableSize.ToList();

                List<string> Material = new List<string>();
                Material.Add("Titanium");
                Material.Add("Plastic");
                Material.Add("Plastic Metal");
                ViewBag.Material = Material.ToList();

                List<string> shape = new List<string>();
                shape.Add("Round");
                shape.Add("Square");
                shape.Add("Aviator");
                shape.Add("Polygon");
                shape.Add("Cat Eye");
                ViewBag.shape = shape.ToList();

                //ViewBag.Colors = dbEntity.tblVariation.Distinct().Select(x => x.ColorCode).ToList();
                List<tblColors> colour = new List<tblColors>();
                colour = dbEntity.tblColors.ToList();
                ViewBag.colour = colour;

                //Maintaint state of all dropdown values
                ViewBag.StateGendervalue = ddlgender;
                ViewBag.StateMaterial = ddlMaterial;
                ViewBag.StateAvailableSize = ddlAvailableSize;
                ViewBag.Stateshape = ddlshape;


                //Split array in choma separate and quotes and pass to cwhere 
                //#Gender
                if (ddlgender != null)
                {
                    foreach (var item in ddlgender)
                    {
                        genderfilters += "'" + item + "'" + ",";
                    }
                    genderfilters = genderfilters.Remove(genderfilters.Length - 1, 1);
                    cwhere += " and   Gender in (" + genderfilters + ") ";
                }

                //#Material
                if (ddlMaterial != null)
                {
                    foreach (var item in ddlMaterial)
                    {
                        materialfilters += "'" + item + "'" + ",";
                    }
                    materialfilters = materialfilters.Remove(materialfilters.Length - 1, 1);
                    cwhere += " and   Material in (" + materialfilters + ") ";
                }

                //#Available Sizes
                if (ddlAvailableSize != null)
                {
                    foreach (var item in ddlAvailableSize)
                    {
                        availablesizesfilters += "'" + item + "'" + ",";
                    }
                    availablesizesfilters = availablesizesfilters.Remove(availablesizesfilters.Length - 1, 1);
                    cwhere += " and   AvailableSize in (" + availablesizesfilters + ") ";
                }

                //#Available Sizes
                if (ddlshape != null)
                {
                    foreach (var item in ddlshape)
                    {
                        shapesfilters += "'" + item + "'" + ",";
                    }
                    shapesfilters = shapesfilters.Remove(shapesfilters.Length - 1, 1);
                    cwhere += " and   shape in (" + shapesfilters + ") ";
                }



                //var materialfilters = "";
                //var availablesizesfilters = "";
                //var shapesfilters = "";
                cwhere += "and ProductCategory = 'Eyeglass' ";

                ViewBag.ProductList = dbEntity.Sp_Get_Product_List_Filter("Eyeglasses", Userid, cwhere).ToList();
            }
            catch (Exception ex)
            {

            }
            return View();
        }


        [HttpPost]
        public ActionResult glassesfilter(string glassestype, string[] ddlMaterial, string[] ddlAvailableSize, string[] ddlshape, string[] ddlgender, string[] ddlcolor,int width=0)
        {
            ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            string cwhere = "";
            var genderfilters = "";
            var materialfilters = "";
            var availablesizesfilters = "";
            var shapesfilters = "";
            var colorfilters = "";

            int Userid = 0;


            //Userid = Convert.ToInt32(Session["UserID"]);
            HttpCookie _UserID = Request.Cookies["_UserID"];
            if (_UserID.Value != null & _UserID.Value != "")
            {
                Userid = Convert.ToInt32(_UserID.Value);
                Session["UserID"] = Convert.ToInt32(_UserID.Value);
            }
            else
            {
                Userid = Convert.ToInt32(Session["UserID"]);
            }
            try
            {


                //Shape Filter

                if (ddlshape != null)
                {
                    foreach (var item in ddlshape)
                    {
                        shapesfilters += "'" + item + "'" + ",";
                    }
                    shapesfilters = shapesfilters.Remove(shapesfilters.Length - 1, 1);
                    cwhere += " and   shape in (" + shapesfilters + ") ";
                }

                //#Material
                if (ddlMaterial != null)
                {
                    foreach (var item in ddlMaterial)
                    {
                        materialfilters += "'" + item + "'" + ",";
                    }
                    materialfilters = materialfilters.Remove(materialfilters.Length - 1, 1);
                    cwhere += " and   Material in (" + materialfilters + ") ";
                }

                //#Available Sizes
                if (ddlAvailableSize != null)
                {
                    foreach (var item in ddlAvailableSize)
                    {
                        availablesizesfilters += "'" + item + "'" + ",";
                    }
                    availablesizesfilters = availablesizesfilters.Remove(availablesizesfilters.Length - 1, 1);
                    cwhere += " and   AvailableSize in (" + availablesizesfilters + ") ";
                }

                //#Gender Filter
                if (ddlgender != null)
                {
                    foreach (var item in ddlgender)
                    {
                        genderfilters += "'" + item + "'" + ",";
                    }
                    genderfilters = genderfilters.Remove(genderfilters.Length - 1, 1);
                    cwhere += " and   Gender in ('UniSex'," + genderfilters + ") ";
                }



                if (ddlcolor != null)
                {
                    foreach (var item in ddlcolor)
                    {
                        colorfilters += "'" + item + "'" + ",";
                    }
                    colorfilters = colorfilters.Remove(colorfilters.Length - 1, 1);
                    cwhere += " and    C.colorname in (" + colorfilters + ") ";
                }

                if(width != null && width>0)
                {
                    cwhere += " and   V.FrameAWidth between "+width+" and 110 ";
                }


                ViewBag.ProductList = dbEntity.Sp_Get_Product_List_Filter(glassestype, Userid, cwhere).ToList();
                return Json(ViewBag.ProductList, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json("-1", JsonRequestBehavior.AllowGet);
            }

            return Json(1, JsonRequestBehavior.AllowGet);

        }
        public ActionResult Sunglassess(string[] ddlgender, string[] ddlMaterial, string[] ddlAvailableSize, string[] ddlshape)
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
                string cwhere = "";
                var genderfilters = "";
                var materialfilters = "";
                var availablesizesfilters = "";
                var shapesfilters = "";
                int Userid = 0;
                HttpCookie _UserID = Request.Cookies["_UserID"];
                if (_UserID.Value != null & _UserID.Value != "")
                {
                    Userid = Convert.ToInt32(_UserID.Value);
                    Session["UserID"] = Convert.ToInt32(_UserID.Value);
                }
                else
                {
                    Userid = Convert.ToInt32(Session["UserID"]);
                }
                try
                {
                    //Dropdown List Values
                    List<string> Gender = new List<string>();
                    Gender.Add("Men");
                    Gender.Add("Women");
                    Gender.Add("Trans");
                    ViewBag.Genderlist = Gender.ToList();

                    List<string> AvailableSize = new List<string>();
                    AvailableSize.Add("Medium");
                    AvailableSize.Add("Large");
                    AvailableSize.Add("Small");
                    ViewBag.AvailableSize = AvailableSize.ToList();

                    List<string> Material = new List<string>();
                    Material.Add("Titanium");
                    Material.Add("Plastic");
                    Material.Add("Plastic Metal");
                    ViewBag.Material = Material.ToList();

                    List<string> shape = new List<string>();
                    shape.Add("Round");
                    shape.Add("Square");
                    shape.Add("Aviator");
                    shape.Add("Polygon");
                    shape.Add("Cat Eye");
                    ViewBag.shape = shape.ToList();

                    ViewBag.Colors = dbEntity.tblVariation.Distinct().Select(x => x.ColorCode).ToList();

                    //Maintaint state of all dropdown values
                    ViewBag.StateGendervalue = ddlgender;
                    ViewBag.StateMaterial = ddlMaterial;
                    ViewBag.StateAvailableSize = ddlAvailableSize;
                    ViewBag.Stateshape = ddlshape;


                    //Split array in choma separate and quotes and pass to cwhere 
                    //#Gender
                    if (ddlgender != null)
                    {
                        foreach (var item in ddlgender)
                        {
                            genderfilters += "'" + item + "'" + ",";
                        }
                        genderfilters = genderfilters.Remove(genderfilters.Length - 1, 1);
                        cwhere += " and   Gender in (" + genderfilters + ") ";
                    }

                    //#Material
                    if (ddlMaterial != null)
                    {
                        foreach (var item in ddlMaterial)
                        {
                            materialfilters += "'" + item + "'" + ",";
                        }
                        materialfilters = materialfilters.Remove(materialfilters.Length - 1, 1);
                        cwhere += " and   Material in (" + materialfilters + ") ";
                    }

                    //#Available Sizes
                    if (ddlAvailableSize != null)
                    {
                        foreach (var item in ddlAvailableSize)
                        {
                            availablesizesfilters += "'" + item + "'" + ",";
                        }
                        availablesizesfilters = availablesizesfilters.Remove(availablesizesfilters.Length - 1, 1);
                        cwhere += " and   AvailableSize in (" + availablesizesfilters + ") ";
                    }

                    //#Available Sizes
                    if (ddlshape != null)
                    {
                        foreach (var item in ddlshape)
                        {
                            shapesfilters += "'" + item + "'" + ",";
                        }
                        shapesfilters = shapesfilters.Remove(shapesfilters.Length - 1, 1);
                        cwhere += " and   shape in (" + shapesfilters + ") ";
                    }



                    //var materialfilters = "";
                    //var availablesizesfilters = "";
                    //var shapesfilters = "";
                    cwhere += "and ProductCategory = 'Sunglass' ";

                    ViewBag.ProductList = dbEntity.Sp_Get_Product_List_Filter("Sunglasses", Userid, cwhere).ToList();

                    List<tblColors> colour = new List<tblColors>();
                    colour = dbEntity.tblColors.ToList();
                    ViewBag.colour = colour;
                }
                catch (Exception ex)
                {

                }
                return View();
            }
            catch (Exception ex)
            {

            }
            return View();
        }
        [Customexception]
        public ActionResult Accessories()
        {
            try
            {
                string cwhere = "";
                int Userid = 0;
                HttpCookie _UserID = Request.Cookies["_UserID"];
                if (_UserID.Value != null & _UserID.Value != "")
                {
                    Userid = Convert.ToInt32(_UserID.Value);
                    Session["UserID"] = Convert.ToInt32(_UserID.Value);
                }
                else
                {
                    Userid = Convert.ToInt32(Session["UserID"]);
                }
                try
                {


                    //var materialfilters = "";
                    //var availablesizesfilters = "";
                    //var shapesfilters = "";
                    cwhere = "and ProductCategory = 'Accessory' ";
                    ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
                    ViewBag.ProductList = dbEntity.Sp_Get_Product_List_Filter("Accessory", Userid, cwhere).ToList();
                }
                catch (Exception ex)
                {
                    ViewBag.error = ex.Message;
                }
                return View();
            }
            catch (Exception ex)
            {

            }
            return View();
        }

        [Customexception]
        public ActionResult OurStory()
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            }
            catch (Exception ex)
            {

            }
            return View();
        }
        [Customexception]
        public ActionResult News()
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
            }
            catch (Exception ex)
            {

            }
            return View();
        }
        [Customexception]
        public ActionResult Contact()
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntity.Sp_Get_Product_List(0, "").ToList();
                ViewBag.message = "";
            }
            catch (Exception ex)
            {

            }
            return View();
        }
        [HttpPost]
        [Customexception]
        public ActionResult Contact(string email, string fname, string lname, string subject, string message, string phone)
        {
            try
            {

                //Guid activationCode = Guid.NewGuid();

                tblSetting sa = dbEntity.tblSettings.Find(3);
                using (MailMessage mm = new MailMessage(sa.Email, sa.Email))
                {

                    mm.Subject = subject;
                    string body = "Hello,";
                    body += "<br /><br />You received a message from " + fname + " " + lname + "(" + email + ")";
                    body += "<br /><br />Phone Number: " + phone + "<br /><br />";
                    body += message;
                    mm.Body = body;
                    mm.IsBodyHtml = true;
                    SmtpClient smtp = new SmtpClient();
                    smtp.Host = sa.SMTP;
                    smtp.EnableSsl = Convert.ToBoolean(sa.IsActive);
                    NetworkCredential NetworkCred = new NetworkCredential(sa.Email, sa.Password);
                    smtp.UseDefaultCredentials = true;
                    smtp.Credentials = NetworkCred;
                    smtp.Port = Convert.ToInt32(sa.Port);
                    smtp.Send(mm);
                }
                ViewBag.message = "We have received your message.Contact you soon";
                return View();
            }
            catch (Exception ex)
            {
                return View();
                throw;
            }

        }

    }
}