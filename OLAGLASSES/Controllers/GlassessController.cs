using Newtonsoft.Json;
using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    [FilterConfig.NoDirectAccess]
    [FilterConfig.AuthorizeActionFilter]
    public class GlassessController : Controller
    {

        private void GenerateThumbnails(double scaleFactor, Stream sourcePath, string targetPath)
        {
            using (var image = Image.FromStream(sourcePath))
            {
                // can given width of image as we want  
                var newWidth = (int)(image.Width * scaleFactor);
                // can given height of image as we want  
                var newHeight = (int)(image.Height * scaleFactor);
                var thumbnailImg = new Bitmap(newWidth, newHeight);
                var thumbGraph = Graphics.FromImage(thumbnailImg);
                thumbGraph.CompositingQuality = CompositingQuality.HighQuality;
                thumbGraph.SmoothingMode = SmoothingMode.HighQuality;
                thumbGraph.InterpolationMode = InterpolationMode.HighQualityBicubic;
                var imageRectangle = new Rectangle(0, 0, newWidth, newHeight);
                thumbGraph.DrawImage(image, imageRectangle);
                thumbnailImg.Save(targetPath, image.RawFormat);
            }
        }
        OlaGlassesEntities dbEntity = new OlaGlassesEntities();
        [Customexception]
        public ActionResult Index(string message)
        {
            ViewBag.message = message;
            List<tblProduct> products = new List<tblProduct>();
            products = dbEntity.tblProducts.Where(x => x.ProductCategory != "Accessory").ToList();
            ViewBag.ProductList = products;
            return View();
        }
        [Customexception]
        public ActionResult Create(int? id)
        {
            tblProduct product = new tblProduct();
            if (id>0)
            {
                 product = dbEntity.tblProducts.Find(id);

            }
            else
            {
                product.Title = "";
                product.shape = "";
                product.Colour = "";
                product.Material = "";
                product.Brand = "";
                product.Gender = "";
                product.AdditionalInfo = "";
                product.AvailableSize = "";
                product.Price =0;
                product.Cost = 0;
                product.Manufacturer = "";
                product.Model = "";
                product.OrignalCode = "";
                product.Mgf_Code = "";
                product.Rim = "";
                product.Sticker = "";
                product.Feature = "";
                product.ProductCategory = "";
                product.ReleatedTo = 0;
                product.SellinClinic = "";
                product.SKUNumber = "";
               
            }
            List<tblProduct> tblProducts = dbEntity.tblProducts.Where(x => x.ProductCategory != "Accessory").ToList();
            ViewBag.ProductList = tblProducts;
            return View(product);
        }
        [HttpPost]
        [Customexception]
        public ActionResult Create(tblProduct product)
        {
            if(product.SKUNumber==null)
            {
                product.SKUNumber = "";
            }
            
            if (product.GlassID>0)
            {
                dbEntity.Entry(product).State = EntityState.Modified;
                dbEntity.SaveChanges();
                return RedirectToAction("Index", new { message = "Record Updated Successfully" });

            }
            else
            {
                dbEntity.tblProducts.Add(product);
                dbEntity.SaveChanges();
                return RedirectToAction("Index", new { message = "Record Added Successfully" });
            }
            
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Customexception]
        public ActionResult DeleteData(int? id)
        {
            try
            {

                    tblProduct make = dbEntity.tblProducts.Find(id);
                    if (make != null)
                    {
                        dbEntity.tblProducts.Remove(make);
                        dbEntity.SaveChanges();
                    }
                   
               
                return RedirectToAction("Index" , new { message="Record Deleted Successfully"});
            }
            catch (Exception)
            {

                throw;
            }

        }

        [HttpPost]
        public JsonResult deletevariationimage(int? variationid)
        {
            try
            {
                var variationimages= dbEntity.tblvariationimages.Where(a=>a.Variationimageid==variationid);
                dbEntity.tblvariationimages.RemoveRange(variationimages);
                dbEntity.SaveChanges();
                return Json("Deleted", JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {

                return Json("Exception", JsonRequestBehavior.AllowGet);
            }

        }



        [Customexception]
        public ActionResult VariationIndex(int id,string message)
        {
            ViewBag.message = message;
            List<tblVariation> variations = new List<tblVariation>();
            variations = dbEntity.tblVariation.Where(x => x.ProductID == id).ToList();
            tblProduct p = dbEntity.tblProducts.Find(id);
            ViewBag.Productname = p.Title;
            ViewBag.GlassID = p.GlassID;
            ViewBag.variationstList = variations;
            return View();
        }
        [Customexception]
        public ActionResult VariationCreate(int? id, int productid)
        {
            ViewBag.color = dbEntity.tblColors.ToList();
            tblVariation product = new tblVariation();
            if (id > 0)
            {
                product = dbEntity.tblVariation.Find(id);
                ViewBag.variationimages = dbEntity.tblvariationimages.Where(a => a.VariationID == id && a.ProductID == productid).ToList();
            }
            else
            {
                var path = "/ProjectImages/Variations/placeholder.jpg";
                var Sideviewpath = "/ProjectImages/Variations/placeholder.jpg";
                product.VariationID = 0;
                product.ColorCode = "";
                product.Color1 = "";
                product.Color2 = "";
                product.size = "";
                product.FrameAWidth = 0;
                product.FrameBHeight = 0;
                product.FrameED = "";
                product.FrameDBBridger = "";
                product.FrameTempleLegs = "";
                product.FrameTotalWidth ="";
                product.MinPDNeg = "";
                product.MinPDPositive = "";
                product.ImagePath = path;
                product.SideViewImagePath = Sideviewpath;
                product.ProductID = productid;


            }

            return View(product);
        }
        [HttpPost]
        [Customexception]
        public ActionResult VariationCreate(tblVariation product, HttpPostedFileBase[] Image, HttpPostedFileBase SideViewImagePath)
        {
            int prod = (int)product.ProductID;
            int VariationID = (int)product.VariationID;
            //below code is for single image upload          
            //if (Image != null)
            //{
            //    var path = Path.Combine(Server.MapPath("/ProjectImages/Variations/"), Image.FileName.Replace(" " ,"_"));
            //    var path1 = Path.Combine(("/ProjectImages/Variations/"), Image.FileName.Replace(" ", "_"));
            //    product.ImagePath = path1;
            //    Image.SaveAs(path);
            //}

            tblvariationimages tvi = new tblvariationimages();
            if (SideViewImagePath != null)
            {
                var path = Path.Combine(Server.MapPath("/ProjectImages/Variations/"), SideViewImagePath.FileName.Replace(" ", "_"));
                var path1 = Path.Combine(("/ProjectImages/Variations/"), SideViewImagePath.FileName.Replace(" ", "_"));
                product.SideViewImagePath = path1;
                //SideViewImagePath.SaveAs(path);
                Stream strm = SideViewImagePath.InputStream;
                GenerateThumbnails(0.3, strm, path);
            }

            if (product.VariationID > 0)
            {
                foreach (var item in Image)
                {
                    if(item !=null)
                    {
                        var path = Path.Combine(Server.MapPath("/ProjectImages/Variations/"), item.FileName.Replace(" ", "_"));
                        var path1 = Path.Combine(("/ProjectImages/Variations/"), item.FileName.Replace(" ", "_"));
                        product.ImagePath = path1;
                        //item.SaveAs(path);
                        Stream strm = item.InputStream;
                        GenerateThumbnails(0.3, strm, path);


                        tvi.ProductID = (int)product.ProductID;
                        tvi.VariationID = (int)product.VariationID;
                        tvi.ImagePath = path1;
                        dbEntity.tblvariationimages.Add(tvi);
                        dbEntity.SaveChanges();
                    }
                   
                }
                int c = dbEntity.tblvariationimages.Where(x => x.ProductID == prod && x.VariationID== VariationID).Count();
                if (c ==0)
                {
                    tvi.ProductID = (int)product.ProductID;
                    tvi.VariationID = (int)product.VariationID;
                    tvi.ImagePath = "/ProjectImages/Variations/placeholder.jpg";
                    dbEntity.tblvariationimages.Add(tvi);
                    dbEntity.SaveChanges();
                }
                dbEntity.Entry(product).State = EntityState.Modified;
                dbEntity.SaveChanges();
                return RedirectToAction("VariationIndex", new { id = product.ProductID, message = "Record Updated Successfully" });

            }
            else
            {
                dbEntity.tblVariation.Add(product);
                dbEntity.SaveChanges();

                Int64 id = 0;
                id = Convert.ToInt64(product.VariationID);
                foreach (var item in Image)
                {
                    if (item != null)
                    {
                        var path = Path.Combine(Server.MapPath("/ProjectImages/Variations/"), item.FileName.Replace(" ", "_"));
                        var path1 = Path.Combine(("/ProjectImages/Variations/"), item.FileName.Replace(" ", "_"));
                        product.ImagePath = path1;
                        //item.SaveAs(path);
                        Stream strm = item.InputStream;
                        GenerateThumbnails(0.3, strm, path);
                        tvi.ProductID = (int)product.ProductID;
                        tvi.VariationID = (int)id;
                        tvi.ImagePath = path1;
                        dbEntity.tblvariationimages.Add(tvi);
                        dbEntity.SaveChanges();
                    }
                }
                int c = dbEntity.tblvariationimages.Where(x => x.ProductID == prod && x.VariationID == VariationID).Count();
                if (c == 0) { 
                    tvi.ProductID = (int)product.ProductID;
                    tvi.VariationID = (int)product.VariationID;
                    tvi.ImagePath = "/ProjectImages/Variations/placeholder.jpg";
                    dbEntity.tblvariationimages.Add(tvi);
                    dbEntity.SaveChanges();
                }
                return RedirectToAction("VariationIndex", new { id = product.ProductID, message = "Record Added Successfully" });
            }

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Customexception]
        public ActionResult VariationDeleteData(int? id,int Productid)
        {
            try
            {

                tblVariation make = dbEntity.tblVariation.Find(id);
                if (make != null)
                {
                    dbEntity.tblVariation.Remove(make);
                    dbEntity.SaveChanges();
                }


                return RedirectToAction("VariationIndex", new { id=Productid,message = "Record Deleted Successfully" });
            }
            catch (Exception)
            {

                throw;
            }

        }


        public  JsonResult GetCoode(string code,int glassID)
        {
            OlaGlassesEntities dbEntity1 = new OlaGlassesEntities();
            int ret = 0;

            List<tblVariation> variation1 = dbEntity1.tblVariation.ToList();
            tblVariation variation = dbEntity1.tblVariation.Where(x => x.ColorCode == code && x.ProductID == glassID).FirstOrDefault();
            if(variation!=null)
            {
                ret = 1;
            }
            
            return Json(ret,JsonRequestBehavior.AllowGet);
        }
    }
}