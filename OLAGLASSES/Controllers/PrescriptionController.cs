using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    [FilterConfig.NoDirectAccess]
    [FilterConfig.AuthorizeActionFilter]
    public class PrescriptionController : Controller
    {
        // GET: Prescription
        OlaGlassesEntities dbEntity = new OlaGlassesEntities();
        [Customexception]
        public ActionResult Index(int? id, string message)
        {
            HttpCookie UserRolecookie = Request.Cookies["_UserRole"];
            string rolevalue = UserRolecookie.Value;

            ViewBag.message = message;
            ViewBag.UserID = id;
            List<tblUserPrescription> prescriptions = new List<tblUserPrescription>();
            if (rolevalue == "admin")
            {
                prescriptions = dbEntity.tblUserPrescription.OrderByDescending(x => x.PrescriptionID).ToList();
            }
            else
            {
                prescriptions = dbEntity.tblUserPrescription.Where(x => x.UserID == id).OrderByDescending(x => x.PrescriptionID).ToList();
            }
            ViewBag.rolevalue = rolevalue;
            ViewBag.PrescriptionList = prescriptions;
            return View();
        }
        [Customexception]
        public ActionResult Create(int? id, int UserID)
        {
            ViewBag.SPH = dbEntity.tblSizes.Where(x => x.Type == "SPH").ToList();
            ViewBag.CYL = dbEntity.tblSizes.Where(x => x.Type == "CYL").ToList();
            ViewBag.ADD = dbEntity.tblSizes.Where(x => x.Type == "ADD").ToList();
            ViewBag.PD = dbEntity.tblSizes.Where(x => x.Type == "PD").ToList();
            ViewBag.UserID = UserID;
            tblUserPrescription product = new tblUserPrescription();
            if (id > 0)
            {
                product = dbEntity.tblUserPrescription.Find(id);
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
                product.UserID = UserID;

            }
            return View(product);
        }
        [HttpPost]
        [Customexception]
        public ActionResult Create(tblUserPrescription product, HttpPostedFileBase Image, string pdimage)
        {

            string MainRoot = "";
            if (Image != null)
            {
                //var ext = Path.GetExtension(Image.FileName);

                var path = Path.Combine(Server.MapPath("~/ProjectImages/Prescription"), Image.FileName.Replace(" ", "_"));
                var path1 = Path.Combine(("\\ProjectImages\\Prescription"), Image.FileName.Replace(" ", "_"));
                product.PrescriptionImage = path1;
                Image.SaveAs(path);
            }


            if (pdimage != "" && pdimage != null)
            {



                //Convert Base64 string to Byte Array.
                byte[] bytes = Convert.FromBase64String(pdimage);
                //Save the Byte Array as Image File.

                //create directory for image if not exists
                MainRoot = "/ProjectImages/Prescription/" + product.ProductID + "/";
                bool exists = System.IO.Directory.Exists(Server.MapPath(MainRoot));
                if (!exists)
                    System.IO.Directory.CreateDirectory(Server.MapPath(MainRoot));

                pdimage = string.Format("/ProjectImages/Prescription/" + product.ProductID + "/{0}.png", product.UserID + "-PDImage-" + product.ProductID);

                System.IO.File.WriteAllBytes(Server.MapPath(pdimage), bytes);
                product.PDImage = pdimage;
            }

            if (product.PrescriptionID > 0)
            {
                dbEntity.Entry(product).State = EntityState.Modified;
                dbEntity.SaveChanges();
                return RedirectToAction("Index", new { id = product.UserID, message = "Record Updated Successfully" });

            }
            else
            {
                dbEntity.tblUserPrescription.Add(product);
                dbEntity.SaveChanges();
                return RedirectToAction("Index", new { id = product.UserID, message = "Record Added Successfully" });
            }

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Customexception]
        public ActionResult DeleteData(int? id, int UserID)
        {
            try
            {

                tblUserPrescription make = dbEntity.tblUserPrescription.Find(id);
                if (make != null)
                {
                    dbEntity.tblUserPrescription.Remove(make);
                    dbEntity.SaveChanges();
                }


                return RedirectToAction("Index", new { id = UserID, message = "Record Deleted Successfully" });
            }
            catch (Exception)
            {

                throw;
            }

        }
    }
}