using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    public class ClientController : Controller
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
        [Customexception]
        // GET: Client
        public ActionResult dashboard()
        {
            return View();
        }
        [Customexception]
        public ActionResult ChangePassword()
        {
            return View();
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


                tblUser User = dbEntities.tblUsers.Where(x => x.UserPass == encryptedpassword && x.UserEmail == Email).FirstOrDefault();
                if (User == null)
                {
                    ViewBag.IsError = "Your old Password is incorrect.";
                    return View();
                }
                else
                {
                    string encryptedpassword1 = Encrypt(newPassword, "sblw-3hn8-sqoy19");
                    User.UserPass = encryptedpassword1;
                    dbEntities.Entry(User).State = EntityState.Modified;
                    dbEntities.SaveChanges();
                    ViewBag.IsSuccess = "Password change successfully.";
                    return View();
                }
            }
            catch (Exception)
            {

                throw;
            }

        }
        [Customexception]
        public ActionResult PersonalInfo(int? id, string Ismessage)
        {
            ViewBag.IsError = Ismessage;
            tblUser user = new tblUser();
            if (id == 0)
            {
                var path = "/ProjectImages/UserImages/user.jpg";
                var path1 = "/ProjectImages/UserImages/banner.png";
                user.UserEmail = "";
                user.Address = "";
                user.Phone = "";
                user.Firstname = "";
                user.Lastname = "";
                user.UserImage = path;
                user.Gender = "";
                user.CoverPhoto = path1;
            }
            else
            {

                user = dbEntities.tblUsers.Find(id);
                if (user.UserImage == null)
                {
                    var path = "/ProjectImages/UserImages/user.jpg";
                    user.UserImage = path;
                }
                if (user.CoverPhoto == null)
                {
                    var path = "/ProjectImages/UserImages/banner.png";
                    user.CoverPhoto = path;
                }
            }
            return View(user);
        }




        [HttpPost]
        [Customexception]
        public ActionResult PersonalInfo(tblUser user, HttpPostedFileBase Image, HttpPostedFileBase ImageCoverPhoto)
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
           

            if (ImageCoverPhoto != null)
            {
                var ext = Path.GetExtension(ImageCoverPhoto.FileName);
                string myfile = user.Firstname + "_" + user.UserID + ext;
                var path = Path.Combine(Server.MapPath("~/ProjectImages/UserCoverImages"), myfile);
                var path1 = Path.Combine(("/ProjectImages/UserCoverImages/"), myfile);
                user.CoverPhoto = path1;
                ImageCoverPhoto.SaveAs(path);
            }
           
            using (var context = new OlaGlassesEntities())
            {
                user.UserStatus = 1;
                user.CreatedDate = DateTime.Now;
                context.Entry(user).State = EntityState.Modified;
                context.SaveChanges();
            }
            Session["UserImage"] = user.UserImage;
            Session["CoverPhoto"] = user.CoverPhoto;
            Session["userName"] = user.Firstname + " " + user.Lastname;
            HttpCookie Namecookie = Request.Cookies["_UserName"];
            HttpCookie Imagecookie = Request.Cookies["_UserImage"];
            HttpCookie CoverImagecookie = Request.Cookies["_CoverImagecookie"];
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

            if (CoverImagecookie == null)
            {
                CoverImagecookie = new HttpCookie("_CoverImagecookie");
                if (user.UserImage == null)
                {
                    CoverImagecookie.Value = "/ProjectImages/UserImages/banner.png";
                }
                else
                {
                    CoverImagecookie.Value = user.CoverPhoto;
                }

                CoverImagecookie.Expires = DateTime.Now.AddDays(30);
            }
            else
            {
                CoverImagecookie.Value = user.CoverPhoto;
            }
            Response.Cookies.Add(CoverImagecookie);



            ViewBag.IsError = "User Updated Successfully";
            return RedirectToAction("PersonalInfo", new { id = user.UserID, Ismessage = "Personal Info Updated Successfully" });
        }

        [Customexception]
        public ActionResult PrescriptionList(int? id, string message)
        {

            HttpCookie UserRolecookie = Request.Cookies["_UserRole"];
            string rolevalue = UserRolecookie.Value;

            ViewBag.message = message;
            ViewBag.UserID = id;
            List<tblUserPrescription> prescriptions = new List<tblUserPrescription>();
            if (rolevalue == "admin")
            {
                prescriptions = dbEntities.tblUserPrescription.OrderByDescending(x => x.PrescriptionID).ToList();
            }
            else
            {
                prescriptions = dbEntities.tblUserPrescription.Where(x => x.UserID == id).OrderByDescending(x => x.PrescriptionID).ToList();
            }
            ViewBag.rolevalue = rolevalue;
            ViewBag.PrescriptionList = prescriptions;
            return View();
        }
        [Customexception]
        public ActionResult Deleteprescriotio(int? id, int prescriptionid)
        {
            try
            {
                var prescription = dbEntities.tblUserPrescription.Where(c => c.PrescriptionID == prescriptionid);
                dbEntities.tblUserPrescription.RemoveRange(prescription);
                dbEntities.SaveChanges();
                return RedirectToAction("PrescriptionList", "Client", new { id = id, message = " " });
            }
            catch (Exception ex)
            {
                ViewBag.error = "Error occur while deleting prescription list" + ex.Message;
            }
            return RedirectToAction("PrescriptionList", "Client", new { id = id, message = " " });

        }

        public ActionResult Addprescription()
        {
            tblUserPrescription prescriptions = new tblUserPrescription();
            try
            {

                int id = 0;
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
                id = Userid;
                ViewBag.SPH = dbEntities.tblSizes.Where(x => x.Type == "SPH").ToList();
                ViewBag.CYL = dbEntities.tblSizes.Where(x => x.Type == "CYL").ToList();
                ViewBag.ADD = dbEntities.tblSizes.Where(x => x.Type == "ADD").ToList();
                ViewBag.PD = dbEntities.tblSizes.Where(x => x.Type == "PD").ToList();
                return View(prescriptions);
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Exception occur while adding prescriotion" + ex.Message;
                return View();
            }


            return View(prescriptions);
        }

        [Customexception]
        public ActionResult EditDeleteprescriotion(int? id, int prescriptionid)
        {
            ViewBag.SPH = dbEntities.tblSizes.Where(x => x.Type == "SPH").ToList();
            ViewBag.CYL = dbEntities.tblSizes.Where(x => x.Type == "CYL").ToList();
            ViewBag.ADD = dbEntities.tblSizes.Where(x => x.Type == "ADD").ToList();
            ViewBag.PD = dbEntities.tblSizes.Where(x => x.Type == "PD").ToList();
            tblUserPrescription prescriptions = new tblUserPrescription();
            try
            {
                ViewBag.UserID = id;
                prescriptions = dbEntities.tblUserPrescription.Find(prescriptionid);
                ViewBag.PrescriptionList = prescriptions;
                return View(prescriptions);
            }
            catch (Exception ex)
            {
                ViewBag.error = "Error occur while editing prescription list" + ex.Message;
            }
            return View(prescriptions);

        }
        [HttpPost]
        [Customexception]
        public ActionResult Saveprescriotion(tblUserPrescription prescriptiondata, int UserID)
        {
            try
            {
                dbEntities.tblUserPrescription.Add(prescriptiondata);
                dbEntities.SaveChanges();
                return RedirectToAction("PrescriptionList", "Client", new { id = UserID, message = "" });
            }
            catch (Exception ex)
            {
                ViewBag.error = "Error occur while editing prescription list" + ex.Message;
            }
            return RedirectToAction("PrescriptionList", "Client", new { id = UserID, message = "" });

        }

        [HttpPost]
        [Customexception]
        public ActionResult Updateprescriotion(tblUserPrescription prescriptiondata, int? id, int prescriptionid)
        {
            try
            {
                ViewBag.UserID = id;
                if (prescriptiondata.PrescriptionID > 0)
                {
                    if(prescriptiondata.Dualpd==0)
                    {
                        prescriptiondata.Rightpd = 0;
                    }
                    
                    dbEntities.Entry(prescriptiondata).State = EntityState.Modified;
                    dbEntities.SaveChanges();
                }
                else
                {
                    if (prescriptiondata.Dualpd == 0)
                    {
                        prescriptiondata.Rightpd = 0;
                    }
                    dbEntities.tblUserPrescription.Add(prescriptiondata);
                    dbEntities.SaveChanges();
                }
               
                return RedirectToAction("PrescriptionList", "Client", new { id = id, message = "" });
            }
            catch (Exception ex)
            {
                ViewBag.error = "Error occur while editing prescription list" + ex.Message;
            }
            return RedirectToAction("PrescriptionList", "Client", new { id = id, message = "" });

        }

        [Customexception]
        public ActionResult Prescriptiondetail(int? id, int Uid)
        {
            ViewBag.SPH = dbEntities.tblSizes.Where(x => x.Type == "SPH").ToList();
            ViewBag.CYL = dbEntities.tblSizes.Where(x => x.Type == "CYL").ToList();
            ViewBag.ADD = dbEntities.tblSizes.Where(x => x.Type == "ADD").ToList();
            ViewBag.PD = dbEntities.tblSizes.Where(x => x.Type == "PD").ToList();
            ViewBag.UserID = Uid;
            tblUserPrescription product = new tblUserPrescription();
            if (id > 0)
            {
                product = dbEntities.tblUserPrescription.Find(id);

            }
            else
            {
                var path = "/ProjectImages/Variations/placeholder.jpg";
                product.r_sph = "0";
                product.r_cyl = "0";
                product.r_axis = "0";
                product.r_add = "0";
                product.l_sph = "0";
                product.l_cyl = "0";
                product.l_axis = "0";
                product.l_add = "0";
                product.PD = 0;
                product.Fname = "";
                product.Lname = "";
                product.prescriptionDate = DateTime.Now;
                product.PrescriptionImage = path;
                product.PDImage = path;
                product.UserID = Uid;

            }
            return View(product);
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
                    orders = dbEntities.tblOrder.Where(x => x.Status == status).OrderByDescending(x => x.OrderID).ToList();
                }
                else
                {
                    orders = dbEntities.tblOrder.OrderByDescending(x => x.OrderID).OrderByDescending(x => x.OrderID).ToList();
                }
            }
            else
            {
                if (status != "All")
                {
                    orders = dbEntities.tblOrder.Where(x => x.userID == id && x.Status == status).OrderByDescending(x => x.OrderID).ToList();
                }
                else
                {
                    orders = dbEntities.tblOrder.Where(x => x.userID == id).OrderByDescending(x => x.OrderID).ToList();
                }
            }
            ViewBag.ordersList = orders;
            ViewBag.UserID = id;
            return View();
        }
        [Customexception]
        public ActionResult addressmanagement(int? id)
        {
            List<tblAddress> order = dbEntities.tblAddress.Where(x => x.userID == id).OrderBy(a => a.BAddress).ToList();
            ViewBag.OrderList = order;
            return View();
        }
        [Customexception]
        public ActionResult Editaddressmanagement(int? id)
        {
            var prescription = dbEntities.tblAddress.Where(c => c.AddressID == id).FirstOrDefault();
            return View(prescription);
        }

        [HttpPost]
        [Customexception]
        public ActionResult Editaddressmanagement(tblAddress address)
        {
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
            dbEntities.Entry(address).State = EntityState.Modified;
            dbEntities.SaveChanges();
            return RedirectToAction("addressmanagement", "Client", new { id = Userid, message = "Address has been updated successfully" });
        }
        [Customexception]
        public ActionResult Deleteaddressmanagement(int? id)
        {

            int Userid = 0;
            try
            {
               
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
                var prescription = dbEntities.tblAddress.Where(c => c.AddressID == id);
                dbEntities.tblAddress.RemoveRange(prescription);
                dbEntities.SaveChanges();
                return RedirectToAction("addressmanagement", "Client", new { id = Userid, message = "Address has been deleted successfully" });
            }
            catch (Exception ex)
            {
                ViewBag.error = "Error occur while deleting prescription list" + ex.Message;
            }
            return RedirectToAction("addressmanagement", "Client", new { id = Userid, message = " " });
            
        }

        [Customexception]
        public ActionResult EmailSubscriptions(int? id=0)
        {
            string email = Convert.ToString(Session["Email"]);
            List<tblEmailSubscribe> emailSubscribes = dbEntities.tblEmailSubscribe.Where(x => x.SubscribeEmail == email).ToList();
            ViewBag.emailSubscribes = emailSubscribes;
            return View();

        }
        [Customexception]
        public ActionResult DeleteSubscription(int? id)
        {

            int Userid = 0;
            try
            {

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
                var prescription = dbEntities.tblEmailSubscribe.Where(c => c.SubscribeID == id);
                dbEntities.tblEmailSubscribe.RemoveRange(prescription);
                dbEntities.SaveChanges();
                return RedirectToAction("EmailSubscriptions", "Client", new { id = 0, message = "Address has been deleted successfully" });
            }
            catch (Exception ex)
            {
                ViewBag.error = "Error occur while deleting prescription list" + ex.Message;
            }
            return RedirectToAction("EmailSubscriptions", "Client", new { id = Userid, message = " " });

        }
    }
}