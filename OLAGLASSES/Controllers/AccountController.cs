using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    [RequireHttps]
    public class AccountController : Controller
    {
        private OlaGlassesEntities dbEntities = new OlaGlassesEntities();
        Utility ut = new Utility();
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
        // GET: Account
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        public ActionResult Logout(string id)
        {
            Session["UserID"] = null;
            Session["userName"] = null;
            Session["Email"] = null;
            Session["Role"] = null;
            //Response.Cookies.Clear();

            HttpCookie userEmailcookie = Request.Cookies["_UserEmail"];
            if (userEmailcookie != null)
            {
                userEmailcookie.Value = null;
            }
            Response.Cookies.Add(userEmailcookie);

            HttpCookie _UserID = Request.Cookies["_UserID"];
            if (_UserID != null)
            {
                _UserID.Value = null;
            }
            Response.Cookies.Add(_UserID);

            HttpCookie _UserName = Request.Cookies["_UserName"];
            if (_UserName != null)
            {
                _UserName.Value = null;
            }
            Response.Cookies.Add(_UserName);

            HttpCookie _UserImage = Request.Cookies["_UserImage"];
            if (_UserImage != null)
            {
                _UserImage.Value = null;
            }
            Response.Cookies.Add(_UserImage);

            HttpCookie _UserRole = Request.Cookies["_UserRole"];
            if (_UserRole != null)
            {
                _UserRole.Value = null;
            }
            Response.Cookies.Add(_UserRole);

            HttpCookie _CoverImagecookie = Request.Cookies["_CoverImagecookie"];
            if (_CoverImagecookie != null)
            {
                _CoverImagecookie.Value = null;
            }
            Response.Cookies.Add(_CoverImagecookie);
            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        [Customexception]
        public ActionResult UserLogin(tblUser UserInformation, bool rememberme)
        {
            tblUser us = new tblUser();
            var UserLoginReult = "";
            try
            {
                string encryptedpassword = Encrypt(UserInformation.UserPass, "sblw-3hn8-sqoy19");
                us = dbEntities.tblUsers.Where(a => a.UserEmail == UserInformation.UserEmail).FirstOrDefault();

                if (us == null)
                {
                    return Json(new { status = "-1", url = Url.Action("Index", "Home") });

                }
                us = dbEntities.tblUsers.Where(a => a.UserEmail == UserInformation.UserEmail && a.UserPass == encryptedpassword).FirstOrDefault();

                if (us == null)
                {
                    return Json(new { status = "-2", url = Url.Action("Index", "Home") });
                }
                else
                {
                    if (us.UserStatus == 0)
                    {
                        return Json(new { status = "-3", url = Url.Action("Index", "Home") });
                    }
                    else if (us.UserStatus >= 1)
                    {
                        Session["UserID"] = us.UserID;
                        Session["userName"] = us.Firstname + " " + us.Lastname;
                        if (us.UserImage == null)
                        {
                            Session["UserImage"] = "/ProjectImages/UserImages/user.jpg";
                        }
                        else
                        {
                            Session["UserImage"] = us.UserImage;
                        }

                        if (us.CoverPhoto == null)
                        {
                            Session["CoverPhoto"] = "/ProjectImages/UserImages/banner.png";
                        }
                        else
                        {
                            Session["CoverPhoto"] = us.CoverPhoto;
                        }

                        Session["Email"] = us.UserEmail;
                        Session["Role"] = us.Role;

                        HttpCookie UserID = Request.Cookies["_UserID"];
                        UserID = new HttpCookie("_UserID");
                        UserID.Value = Convert.ToString(us.UserID);
                        UserID.Expires = DateTime.Now.AddHours(3);
                        Response.Cookies.Add(UserID);

                        HttpCookie Emailcookie = Request.Cookies["_UserEmail"];
                        Emailcookie = new HttpCookie("_UserEmail");
                        Emailcookie.Value = Convert.ToString(UserInformation.UserEmail);
                        Emailcookie.Expires = DateTime.Now.AddDays(1);
                        Response.Cookies.Add(Emailcookie);
                        
                        HttpCookie Namecookie = Request.Cookies["_UserName"];
                        Namecookie = new HttpCookie("_UserName");
                        Namecookie.Value = Convert.ToString(us.Firstname + " " + us.Lastname);
                        Namecookie.Expires = DateTime.Now.AddHours(3);
                        Response.Cookies.Add(Namecookie);


                        HttpCookie Imagecookie = Request.Cookies["_UserImage"];
                        Imagecookie = new HttpCookie("_UserImage");
                        if (us.UserImage == null)
                        {
                            Imagecookie.Value = "/ProjectImages/UserImages/user.jpg";
                        }
                        else
                        {
                            Imagecookie.Value = us.UserImage;
                        }

                        Imagecookie.Expires = DateTime.Now.AddHours(3);
                        Response.Cookies.Add(Imagecookie);


                        HttpCookie UserRolecookie = Request.Cookies["_UserRole"];
                        UserRolecookie = new HttpCookie("_UserRole");
                        UserRolecookie.Value = us.Role;
                        UserRolecookie.Expires = DateTime.Now.AddHours(3);
                        Response.Cookies.Add(UserRolecookie);

                        HttpCookie CoverImagecookie = Request.Cookies["_CoverImagecookie"];
                        CoverImagecookie = new HttpCookie("_CoverImagecookie");
                        if (us.CoverPhoto == null)
                        {
                            CoverImagecookie.Value = "/ProjectImages/UserImages/banner.png";
                        }
                        else
                        {
                            CoverImagecookie.Value = us.CoverPhoto;
                        }

                        CoverImagecookie.Expires = DateTime.Now.AddDays(30);
                        Response.Cookies.Add(CoverImagecookie);
                        //Create User Info  Login Cookie if remember me checkbox is checked from login page 
                        if (rememberme == true)
                        {

                            UserID = new HttpCookie("_UserID");
                            UserID.Value = Convert.ToString(us.UserID);
                            UserID.Expires = DateTime.Now.AddDays(30);
                            //UserID Cookie

                            //if (UserID == null)
                            //{
                            //    UserID = new HttpCookie("_UserID");
                            //    UserID.Value = Convert.ToString(us.UserID);
                            //    UserID.Expires = DateTime.Now.AddDays(30);
                            //}
                            //else
                            //{
                            //    UserID.Value = Convert.ToString(us.UserID);
                            //}
                            Response.Cookies.Add(UserID);

                            //Email Cookie
                          
                            //if (Emailcookie == null)
                            //{
                            //    Emailcookie = new HttpCookie("_UserEmail");
                            //    Emailcookie.Value = Convert.ToString(UserInformation.UserEmail);
                            //    Emailcookie.Expires = DateTime.Now.AddDays(30);
                            //}
                            //else
                            //{
                            //    Emailcookie.Value = Convert.ToString(UserInformation.UserEmail);
                            //}

                            Emailcookie = new HttpCookie("_UserEmail");
                            Emailcookie.Value = Convert.ToString(UserInformation.UserEmail);
                            Emailcookie.Expires = DateTime.Now.AddDays(30);
                            Response.Cookies.Add(Emailcookie);


                            //Name Cookie
                           
                            //if (Namecookie == null)
                            //{
                            //    Namecookie = new HttpCookie("_UserName");
                            //    Namecookie.Value = Convert.ToString(us.Firstname + " " + us.Lastname);
                            //    Namecookie.Expires = DateTime.Now.AddDays(30);
                            //}
                            //else
                            //{
                            //    Namecookie.Value = Convert.ToString(us.Firstname + " " + us.Lastname);
                            //}
                            Namecookie = new HttpCookie("_UserName");
                            Namecookie.Value = Convert.ToString(us.Firstname + " " + us.Lastname);
                            Namecookie.Expires = DateTime.Now.AddDays(30);
                            Response.Cookies.Add(Namecookie);

                            //Image Cookie
                            
                            //if (Imagecookie == null)
                            //{
                            //    Imagecookie = new HttpCookie("_UserImage");
                            //    if (us.UserImage == null)
                            //    {
                            //        Imagecookie.Value = "/ProjectImages/UserImages/user.jpg";
                            //    }
                            //    else
                            //    {
                            //        Imagecookie.Value = us.UserImage;
                            //    }
                                
                            //    Imagecookie.Expires = DateTime.Now.AddDays(30);
                            //}
                            //else
                            //{
                            //    Imagecookie.Value = us.UserImage;
                            //}

                            Imagecookie = new HttpCookie("_UserImage");
                            if (us.UserImage == null)
                            {
                                Imagecookie.Value = "/ProjectImages/UserImages/user.jpg";
                            }
                            else
                            {
                                Imagecookie.Value = us.UserImage;
                            }

                            Imagecookie.Expires = DateTime.Now.AddDays(30);
                            Response.Cookies.Add(Imagecookie);


                           
                            CoverImagecookie = new HttpCookie("_CoverImagecookie");
                            if (us.CoverPhoto == null)
                            {
                                CoverImagecookie.Value = "/ProjectImages/UserImages/banner.png";
                            }
                            else
                            {
                                CoverImagecookie.Value = us.CoverPhoto;
                            }

                            CoverImagecookie.Expires = DateTime.Now.AddDays(30);
                            Response.Cookies.Add(CoverImagecookie);
                            //User Role Cookie

                            //if (UserRolecookie == null)
                            //{
                            //    UserRolecookie = new HttpCookie("_UserRole");
                            //    UserRolecookie.Value = us.Role;
                            //    UserRolecookie.Expires = DateTime.Now.AddDays(30);
                            //}
                            //else
                            //{
                            //    UserRolecookie.Value = us.Role;
                            //}

                            UserRolecookie = new HttpCookie("_UserRole");
                            UserRolecookie.Value = us.Role;
                            UserRolecookie.Expires = DateTime.Now.AddDays(30);
                            Response.Cookies.Add(UserRolecookie);



                        }


                        if (us.Role == "admin")
                        {
                            return Json(new { status = "1", url = Url.Action("Index", "Dashboard") });

                        }
                        else if (us.Role == "Candidate")
                        {
                            return Json(new { status = "2", url = Url.Action("dashboard", "Client") });
                            //return Json(new { status = "2", url = Url.Action("Index", "Dashboard") });

                        }

                       


                    }




                }
            }
            catch (Exception ex)
            {
                return Json(new { status = -1, data = ex.Message });
            }

            //return Json(new { status = UserLoginReult, url = Url.Action("Index", "Home") });
            return Json(new { status = "2", url = Url.Action("dashboard", "Client") });
        }


        [HttpPost]
        [Customexception]
        public ActionResult Login(string useremail, string userpassword)
        {

            tblUser us = new tblUser();
            try
            {
                string encryptedpassword = Encrypt(userpassword, "sblw-3hn8-sqoy19");
                us = dbEntities.tblUsers.Where(a => a.UserEmail == useremail).FirstOrDefault();

                if (us == null)
                {
                    ViewBag.Error = "User not exist";
                    return View();
                }
                us = dbEntities.tblUsers.Where(a => a.UserEmail == useremail && a.UserPass == encryptedpassword).FirstOrDefault();

                if (us == null)
                {
                    ViewBag.Error = "Invalid Credentials";
                    return View();
                }
                else
                {
                    if (us.UserStatus == 0)
                    {
                        ViewBag.Error = "User is not active";
                        return View();
                    }
                    else if (us.UserStatus >= 1)
                    {
                        Session["UserID"] = us.UserID;
                        Session["userName"] = us.Firstname + " " + us.Lastname;
                        if (us.UserImage == null)
                        {
                            Session["UserImage"] = "/ProjectImages/UserImages/user.jpg";
                        }
                        else
                        {
                            Session["UserImage"] = us.UserImage;
                        }
                        if (us.CoverPhoto == null)
                        {
                            Session["CoverUserImage"] = "/ProjectImages/UserImages/banner.png";
                        }
                        else
                        {
                            Session["CoverUserImage"] = us.CoverPhoto;
                        }
                        Session["Email"] = us.UserEmail;
                        Session["Role"] = us.Role;
                        Session["UserStatus"] = us.UserStatus;
                        if (us.Role == "admin")
                        {
                            return RedirectToAction("Index", "Dashboard");
                        }
                        else if (us.Role == "Candidate")
                        {

                            return RedirectToAction("Index", "Home");
                        }

                    }
                }

            }
            catch (Exception ex)
            {
                Session["Error"] = ex.Message;
                ViewBag.error = "Exception Occur while Register User : " + Session["Error"];
                return RedirectToAction("ExceptionPage", "Error");
            }

            return View();
        }

        [HttpGet]

        public ActionResult Register()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Register(tblUser UserInformation)
        {
            tblUser user = new tblUser();
            try
            {
                string encryptedpassword = Encrypt(UserInformation.UserPass, "sblw-3hn8-sqoy19");
                var userexists = dbEntities.tblUsers.Where(a => a.UserEmail == UserInformation.UserEmail);

                if (userexists.Count() > 0)
                {
                    return Json(new { status = "-1", url = Url.Action("Index", "Home") });
                }
                else
                {
                    user.UserPass = encryptedpassword;
                    user.UserEmail = UserInformation.UserEmail;
                    user.Firstname = UserInformation.Firstname;
                    user.Lastname = UserInformation.Lastname;
                    user.Role = "Candidate";
                    user.UserStatus = 1;
                    dbEntities.tblUsers.Add(user);
                    dbEntities.SaveChanges();

                    Session["UserID"] = user.UserID;
                    Session["userName"] = user.Firstname + " " + user.Lastname;
                    if (user.UserImage == null)
                    {
                        Session["UserImage"] = "/ProjectImages/UserImages/user.jpg";
                    }
                    else
                    {
                        Session["UserImage"] = user.UserImage;
                    }
                    Session["Email"] = user.UserEmail;
                    Session["Role"] = user.Role;
                    Session["UserStatus"] = user.UserStatus;





                    return Json(new { status = "1", url = Url.Action("Index", "Home") });
                }
                return View();
            }
            catch (Exception ex)
            {

            }
            return View();
        }



        [HttpPost]
        public ActionResult RegisterGoogle(tblUser UserInformation)
        {
            tblUser user = new tblUser();
            try
            {
                UserInformation.UserPass = "1234";
                string encryptedpassword = Encrypt(UserInformation.UserPass, "sblw-3hn8-sqoy19");
                tblUser userexists = dbEntities.tblUsers.Where(a => a.UserEmail == UserInformation.UserEmail).FirstOrDefault();

                if (userexists != null)
                {
                    Session["UserID"] = userexists.UserID;
                    Session["userName"] = userexists.Firstname + " " + user.Lastname;
                    if (userexists.UserImage == null)
                    {
                        Session["UserImage"] = "/ProjectImages/UserImages/user.jpg";
                    }
                    else
                    {
                        Session["UserImage"] = userexists.UserImage;
                    }
                    Session["Email"] = userexists.UserEmail;
                    Session["Role"] = userexists.Role;
                    Session["UserStatus"] = userexists.UserStatus;


                    HttpCookie UserID = Request.Cookies["_UserID"];
                    UserID = new HttpCookie("_UserID");
                    UserID.Value = Convert.ToString(userexists.UserID);
                    UserID.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(UserID);

                    HttpCookie Emailcookie = Request.Cookies["_UserEmail"];
                    Emailcookie = new HttpCookie("_UserEmail");
                    Emailcookie.Value = Convert.ToString(UserInformation.UserEmail);
                    Emailcookie.Expires = DateTime.Now.AddDays(1);
                    Response.Cookies.Add(Emailcookie);

                    HttpCookie Namecookie = Request.Cookies["_UserName"];
                    Namecookie = new HttpCookie("_UserName");
                    Namecookie.Value = Convert.ToString(userexists.Firstname + " " + userexists.Lastname);
                    Namecookie.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(Namecookie);


                    HttpCookie Imagecookie = Request.Cookies["_UserImage"];
                    Imagecookie = new HttpCookie("_UserImage");
                    if (userexists.UserImage == null)
                    {
                        Imagecookie.Value = "/ProjectImages/UserImages/user.jpg";
                    }
                    else
                    {
                        Imagecookie.Value = userexists.UserImage;
                    }

                    Imagecookie.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(Imagecookie);


                    HttpCookie UserRolecookie = Request.Cookies["_UserRole"];
                    UserRolecookie = new HttpCookie("_UserRole");
                    UserRolecookie.Value = userexists.Role;
                    UserRolecookie.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(UserRolecookie);



                    if (userexists.Role == "admin")
                    {
                        return Json(new { status = "1", url = Url.Action("Index", "Dashboard") });

                    }
                    else if (userexists.Role == "Candidate")
                    {
                        return Json(new { status = "2", url = Url.Action("dashboard", "Client") });
                        //return Json(new { status = "2", url = Url.Action("Index", "Dashboard") });

                    }

                    //return Json(new { status = "1", url = Url.Action("Index", "Home") });
                }
                else
                {
                    user.UserImage = UserInformation.UserImage;
                    user.UserPass = encryptedpassword;
                    user.UserEmail = UserInformation.UserEmail;
                    user.Firstname = UserInformation.Firstname;
                    user.Lastname = UserInformation.Lastname;
                    user.Role = "Candidate";
                    user.UserStatus = 2;
                    dbEntities.tblUsers.Add(user);
                    dbEntities.SaveChanges();

                    Session["UserID"] = user.UserID;
                    Session["userName"] = user.Firstname + " " + user.Lastname;
                    if (user.UserImage == null)
                    {
                        Session["UserImage"] = "/ProjectImages/UserImages/user.jpg";
                    }
                    else
                    {
                        Session["UserImage"] = user.UserImage;
                    }
                    Session["Email"] = user.UserEmail;
                    Session["Role"] = user.Role;
                    Session["UserStatus"] = user.UserStatus;


                    HttpCookie UserID = Request.Cookies["_UserID"];
                    UserID = new HttpCookie("_UserID");
                    UserID.Value = Convert.ToString(user.UserID);
                    UserID.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(UserID);

                    HttpCookie Emailcookie = Request.Cookies["_UserEmail"];
                    Emailcookie = new HttpCookie("_UserEmail");
                    Emailcookie.Value = Convert.ToString(UserInformation.UserEmail);
                    Emailcookie.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(Emailcookie);

                    HttpCookie Namecookie = Request.Cookies["_UserName"];
                    Namecookie = new HttpCookie("_UserName");
                    Namecookie.Value = Convert.ToString(UserInformation.Firstname + " " + UserInformation.Lastname);
                    Namecookie.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(Namecookie);


                    HttpCookie Imagecookie = Request.Cookies["_UserImage"];
                    Imagecookie = new HttpCookie("_UserImage");
                    if (UserInformation.UserImage == null)
                    {
                        Imagecookie.Value = "/ProjectImages/UserImages/user.jpg";
                    }
                    else
                    {
                        Imagecookie.Value = UserInformation.UserImage;
                    }

                    Imagecookie.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(Imagecookie);


                    HttpCookie UserRolecookie = Request.Cookies["_UserRole"];
                    UserRolecookie = new HttpCookie("_UserRole");
                    UserRolecookie.Value = UserInformation.Role;
                    UserRolecookie.Expires = DateTime.Now.AddHours(3);
                    Response.Cookies.Add(UserRolecookie);

                    if (user.Role == "admin")
                    {
                        return Json(new { status = "1", url = Url.Action("Index", "Dashboard") });

                    }
                    else if (user.Role == "Candidate")
                    {
                        return Json(new { status = "2", url = Url.Action("dashboard", "Client") });
                        //return Json(new { status = "2", url = Url.Action("Index", "Dashboard") });

                    }

                    //return Json(new { status = "1", url = Url.Action("Index", "Home") });
                }
                //return View();
            }
            catch (Exception ex)
            {

            }
            //return View();
            return Json(new { status = "1", url = Url.Action("Index", "Home") });
        }
        [HttpGet]
        [Customexception]
        public ActionResult Forgetpassword()
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
            }
            catch (Exception ex)
            {

            }
            return View();
        }


        [HttpGet]
        [Customexception]
        public ActionResult Changewebpassword(string E)
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                string Decryptemail = "";
                E = E.Replace(" ", "+");
                Decryptemail = ut.Decrypt(E);

                ViewBag.Email = Decryptemail;
            }
            catch (Exception ex)
            {

            }
            return View();
        }

        [HttpPost]
        [Customexception]
        public ActionResult Changewebpassword(string Email, string password)
        {
            string Decryptemail = "";
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                //Decryptemail = ut.Decrypt(Email);

                string encryptedpassword = Encrypt(password, "sblw-3hn8-sqoy19");
                tblUser us = dbEntities.tblUsers.Where(a => a.UserEmail == Email).FirstOrDefault();
                if (us != null)
                {
                    us.UserPass = encryptedpassword;
                    //dbEntities.tblUsers.Add(us);
                    dbEntities.SaveChanges();
                    return RedirectToAction("Index", "Home");
                }
                return View();



            }
            catch (Exception ex)
            {

            }
            return View();
        }


        [HttpPost]
        [Customexception]
        public ActionResult Forgetpassword(string Email)
        {
            string Encryptemail = "";
            Encryptemail = ut.Encrypt(Email);
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                var Emailsettings = dbEntities.tblSettings.FirstOrDefault();

                var userexists = dbEntities.tblUsers.Where(a => a.UserEmail == Email);

                if (userexists.Count() == 0)
                {
                    ViewBag.Color = "Red";
                    ViewBag.Error = "User Not Exists";
                    return View();
                }
                else
                {
                    using (MailMessage mm = new MailMessage(Emailsettings.Email, Email))
                    {
                        string link = Request.Url.ToString();
                        link = link.Replace("Forgetpassword", "Changewebpassword");
                        mm.Subject = "Reset Password";

                        //string body = "Hello " + Email + ",";
                        //body += "<br /><br />Please click the following link to activate your account";
                        //body += "<br /><a href = '" + link + "?E=" + Encryptemail + "'>Click here to activate your account.</a>";
                        //body += "<br /><br />Thanks";
                        string body = "";
                        body += "<body  style='background-color:white !important'>";
                        body += "<div class='Container' > <div class='row' style='padding:20px !important'> <div class='col-md-6' marginheight='0' topmargin='0' marginwidth='0'  leftmargin='0'> ";
                        body += " <table style='padding:20px !important;background-color: #f2f3f8; max-width:670px;  margin:150 auto;' width='100%' border='0' align='center' cellpadding='0' cellspacing='0'>";
                        body += " <tr > <td>";
                        body += " <table width='95%' border='0' align='center' cellpadding='0' cellspacing='0' style='max-width:670px; background:#f2f3f8; border-radius:3px; text-align:center;-webkit-box-shadow:0' ";

                        body += "<tr><td style='padding: 0 35px; '><a href='#' title='Reset Password' target='_blank'><img width='60% !important' src='https://optical.yehtohoga.com/assets/img/Logo.png' title='logo' alt='logo'></a>";
                        body += "<h1 style='color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;'>Forgot your password?</h1>";
                        body += "<span style='display: inline-block; vertical-align:middle;  border-bottom:1px solid #cecece; width:100px;'></span>";
                        body += "<p style='color:#455056; font-size:15px;line-height:24px; margin:0;'> That's okay, it happens! Click on the button <br/> below to reset your password.</p>";
                        body += "<a href='" + link + "?E=" + Encryptemail + "' style='background:#009B95;text-decoration:none !important; font-weight:500; margin-top:35px; color:#fff;text-transform:uppercase;font-size:14px;padding:10px 24px;display:inline-block;'> Reset Password </a> ";
                        body += "<p>If you have any questions please email us on  <a style='cursor:pointer;text-decoration: underline;color:#0d6efd'> info@olaglasses.com</a>  </p>";
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

                    ViewBag.Color = "green";
                    ViewBag.Error = "Link send to email";
                    ViewBag.Errorstatus = "1";
                    return View();
                }
                
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                
            }
            return View();
        }


        [HttpPost]
     
        public ActionResult Subscribe(string email)
        {
            try
            {
                tblEmailSubscribe emailSubscribe = new tblEmailSubscribe();
                tblEmailSubscribe emailSubscribe1 = dbEntities.tblEmailSubscribe.Where(x => x.SubscribeEmail == email).FirstOrDefault();
                if (emailSubscribe1 !=null)
                {
                    return Json(new { status = "-1", url = Url.Action("Index", "Home") });
                }
                else
                {
                    emailSubscribe.SubscribeEmail = email;
                    emailSubscribe.UserID = Convert.ToInt32(Session["UserID"]);
                    dbEntities.tblEmailSubscribe.Add(emailSubscribe);
                    dbEntities.SaveChanges();
                    return Json(new { status = "1", url = Url.Action("Index", "Home") });
                }
            }
            catch (Exception ex)
            {
                return View();
                throw;
            }

        }

    }
}