using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    public class ProductsController : Controller
    {

        private OlaGlassesEntities dbEntities = new OlaGlassesEntities();
        // GET: Products

        //Old Backup 2022-01-01
        //public ActionResult Product_Details(int? Productid)
        //{
        //    try
        //    {
        //        //Get userid from session
        //        int Userid = 1;
        //        ViewBag.Reviewslist = dbEntities.tblReviews.Where(a => a.GlassID == Productid).ToList();
        //        ViewBag.Reviewscount = dbEntities.tblReviews.Where(a => a.GlassID == Productid).Count();
        //        ViewBag.Reviewsimagescount = dbEntities.tblReviews.Where(a => a.GlassID == Productid && a.ReviewImage != null).Count();

        //        var RatingSum = dbEntities.tblReviews.Where(a => a.GlassID == Productid).Select(a => a.Rating).Sum();
        //        var RatingCount = dbEntities.tblReviews.Where(a => a.GlassID == Productid).Count();
        //        RatingCount = RatingCount * 5;

        //        int AverageRating = 0;
        //        AverageRating = Convert.ToInt32((RatingSum * 5) / RatingCount);
        //        ViewBag.AverageRating = AverageRating;

        //        ViewBag.ReviewsLike = dbEntities.tblReviewLikes.Where(a => a.UserID == Userid && a.Productid == Productid).ToList();
        //        return View();
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //    return View();
        //}

        [HttpPost]

        public JsonResult Virtualtryproducts(int productid)
        {

            try
            {
                ViewBag.VirtualProductList = dbEntities.Sp_Get_Product_VirtualTry_List(productid).ToList();
                return Json(ViewBag.VirtualProductList, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

            }
            return Json(1, JsonRequestBehavior.AllowGet);
        }
        [Customexception]
        public ActionResult Product_Details(int? Productid, int? vid)
        {
            try
            {
                //Get userid from session
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

                ViewBag.Isfav = dbEntities.tblFavourites.Where(x => x.ProductID == Productid && x.UserID == Userid).FirstOrDefault();
                ViewBag.Reviewslist = dbEntities.tblReviews.Where(a => a.GlassID == Productid).ToList();
                ViewBag.Reviewscount = dbEntities.tblReviews.Where(a => a.GlassID == Productid).Count();
                ViewBag.Reviewsimagescount = dbEntities.tblReviews.Where(a => a.GlassID == Productid && a.ReviewImage != null).Count();

                var RatingSum = dbEntities.tblReviews.Where(a => a.GlassID == Productid).Select(a => a.Rating).Sum();
                var RatingCount = dbEntities.tblReviews.Where(a => a.GlassID == Productid).Count();
                RatingCount = RatingCount * 5;

                int AverageRating = 0;
                AverageRating = Convert.ToInt32((RatingSum * 5) / RatingCount);
                ViewBag.AverageRating = AverageRating;

                ViewBag.ReviewsLike = dbEntities.tblReviewLikes.Where(a => a.UserID == Userid && a.Productid == Productid).ToList();

                ViewBag.ReviewsLikecount = dbEntities.tblReviewLikes.Where(a => a.Productid == Productid).ToList();



                tblProduct product = dbEntities.tblProducts.Find(Productid);
                if (product.ProductCategory == "Accessory")
                {
                    ViewBag.Variation = dbEntities.tblglassPictures.Where(x => x.glassID == Productid).ToList();
                }
                else
                {
                    if (vid != null)
                    {
                        ViewBag.variationid = vid;
                    }
                    else
                    {
                        ViewBag.variationid = 0;
                    }
                    ViewBag.Variation = dbEntities.tblVariation.Where(x => x.ProductID == Productid).ToList();
                    List<VariationImages> variation = new List<VariationImages>();
                    if (vid > 0)
                    {
                        var query = (from pd in dbEntities.tblVariation
                                     join od in dbEntities.tblvariationimages on pd.VariationID equals od.VariationID
                                     where pd.ProductID == Productid && od.VariationID == vid
                                     select new
                                     {
                                         Imagepath = od.ImagePath,
                                         Variationimageid = od.Variationimageid,
                                         VariationID = od.VariationID,
                                         ProductID = pd.ProductID,
                                         ColorCode = pd.ColorCode,
                                         Color1 = pd.Color1,
                                         Color2 = pd.Color2,
                                         size = pd.size,
                                         FrameAWidth = pd.FrameAWidth,
                                         FrameBHeight = pd.FrameBHeight,
                                         FrameED = pd.FrameED,
                                         FrameDBBridger = pd.FrameDBBridger,
                                         FrameTempleLegs = pd.FrameTempleLegs,
                                         FrameTotalWidth = pd.FrameTotalWidth,
                                         MinPDPositive = pd.MinPDPositive,
                                         MinPDNeg = pd.MinPDNeg,
                                         CreatedDate = pd.CreatedDate,
                                         SideViewImagePath = pd.SideViewImagePath,
                                         SKUNumber = pd.SKUNumber,
                                     }).ToList();
                        foreach (var dt in query)

                        {
                            variation.Add(new VariationImages
                            {
                                ImagePath = dt.Imagepath,
                                Variationimageid = dt.Variationimageid,
                                VariationID = dt.VariationID,
                                ProductID = dt.ProductID,
                                ColorCode = dt.ColorCode,
                                Color1 = dt.Color1,
                                Color2 = dt.Color2,
                                size = dt.size,
                                FrameAWidth = dt.FrameAWidth,
                                FrameBHeight = dt.FrameBHeight,
                                FrameED = dt.FrameED,
                                FrameDBBridger = dt.FrameDBBridger,
                                FrameTempleLegs = dt.FrameTempleLegs,
                                FrameTotalWidth = dt.FrameTotalWidth,
                                MinPDPositive = dt.MinPDPositive,
                                MinPDNeg = dt.MinPDNeg,
                                CreatedDate = dt.CreatedDate,
                                SideViewImagePath = dt.SideViewImagePath,
                                SKUNumber = dt.SKUNumber,
                            });
                        }
                    }
                    else
                    {
                        var query = (from pd in dbEntities.tblVariation
                                     join od in dbEntities.tblvariationimages on pd.VariationID equals od.VariationID
                                     where pd.ProductID == Productid
                                     select new
                                     {
                                         Imagepath = od.ImagePath,
                                         Variationimageid = od.Variationimageid,
                                         VariationID = od.VariationID,
                                         ProductID = pd.ProductID,
                                         ColorCode = pd.ColorCode,
                                         Color1 = pd.Color1,
                                         Color2 = pd.Color2,
                                         size = pd.size,
                                         FrameAWidth = pd.FrameAWidth,
                                         FrameBHeight = pd.FrameBHeight,
                                         FrameED = pd.FrameED,
                                         FrameDBBridger = pd.FrameDBBridger,
                                         FrameTempleLegs = pd.FrameTempleLegs,
                                         FrameTotalWidth = pd.FrameTotalWidth,
                                         MinPDPositive = pd.MinPDPositive,
                                         MinPDNeg = pd.MinPDNeg,
                                         CreatedDate = pd.CreatedDate,
                                         SideViewImagePath = pd.SideViewImagePath,
                                         SKUNumber = pd.SKUNumber,
                                     }).ToList();
                        foreach (var dt in query)

                        {
                            variation.Add(new VariationImages
                            {
                                ImagePath = dt.Imagepath,
                                Variationimageid = dt.Variationimageid,
                                VariationID = dt.VariationID,
                                ProductID = dt.ProductID,
                                ColorCode = dt.ColorCode,
                                Color1 = dt.Color1,
                                Color2 = dt.Color2,
                                size = dt.size,
                                FrameAWidth = dt.FrameAWidth,
                                FrameBHeight = dt.FrameBHeight,
                                FrameED = dt.FrameED,
                                FrameDBBridger = dt.FrameDBBridger,
                                FrameTempleLegs = dt.FrameTempleLegs,
                                FrameTotalWidth = dt.FrameTotalWidth,
                                MinPDPositive = dt.MinPDPositive,
                                MinPDNeg = dt.MinPDNeg,
                                CreatedDate = dt.CreatedDate,
                                SideViewImagePath = dt.SideViewImagePath,
                                SKUNumber = dt.SKUNumber,
                            });
                        }
                    }





                    ViewBag.Variationimages = variation;


                }

                if (_UserID.Value != null & _UserID.Value != "")
                {
                    Userid = Convert.ToInt32(_UserID.Value);
                    Session["UserID"] = Convert.ToInt32(_UserID.Value);
                }
                else
                {
                    Userid = Convert.ToInt32(Session["UserID"]);
                }
                ViewBag.ProductCategory = product.ProductCategory;
                ViewBag.Userid = Userid;
                ViewBag.ProductList = dbEntities.Sp_Get_Product_List(Userid, "").ToList();
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                ViewBag.VirtualProductList1 = dbEntities.Sp_Get_Product_VirtualTry_List(Productid).ToList();
                ViewBag.ClientReviews = dbEntities.Sp_Get_Five_Reviews().ToList();
                return View(product);
            }
            catch (Exception ex)
            {

            }
            return View();
        }

        [Customexception]
        public ActionResult ProductFavourite(int? id = 0)
        {
            ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
            HttpCookie _UserID = Request.Cookies["_UserID"];
            try
            {
                int UserID = 0;
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
                    var ReviewLikeExist = dbEntities.tblFavourites.Where(a => a.ProductID == id && a.UserID == UserID);

                    if (ReviewLikeExist.Count() > 0)
                    {
                        var ReviewLike = dbEntities.tblFavourites.Where(a => a.ProductID == id && a.UserID == UserID);
                        dbEntities.tblFavourites.RemoveRange(ReviewLike);
                        dbEntities.SaveChanges();
                    }
                    else
                    {
                        tblFavourite tbl = new tblFavourite();
                        tbl.UserID = UserID;
                        tbl.ProductID = id;
                        tbl.CreateDate = DateTime.Now;
                        dbEntities.tblFavourites.Add(tbl);
                        dbEntities.SaveChanges();

                    }

                }
                return RedirectToAction("Product_Details", "Products", new { Productid = id });
            }
            catch (Exception ex)
            {

            }
            return RedirectToAction("Product_Details", "Products", new { Productid = id });
        }

        public JsonResult UpdateLikes(int? status = 0, int? ReviewID = 0, int? GlassID = 0, int? UserID = 0)
        {

            var ReviewLikeCount = 0;
            try
            {

                var ReviewLikeExist = dbEntities.tblReviewLikes.Where(a => a.Productid == GlassID && a.ReviewID == ReviewID && a.UserID == UserID);

                if (ReviewLikeExist.Count() > 0)
                {
                    var ReviewLike = dbEntities.tblReviewLikes.Where(a => a.Productid == GlassID && a.ReviewID == ReviewID && a.UserID == UserID);
                    dbEntities.tblReviewLikes.RemoveRange(ReviewLike);
                    dbEntities.SaveChanges();
                }
                else if (ReviewLikeExist.Count() == 0)
                {

                    tblReviewLike tbl = new tblReviewLike();
                    tbl.UserID = UserID;
                    tbl.ReviewID = ReviewID;
                    tbl.Productid = GlassID;
                    dbEntities.tblReviewLikes.Add(tbl);
                    dbEntities.SaveChanges();
                }

                ReviewLikeCount = dbEntities.tblReviewLikes.Where(a => a.Productid == GlassID && a.ReviewID == ReviewID).Count();

                return Json(ReviewLikeCount);
            }
            catch (Exception ex)
            {
                return Json("-1");
            }
            return Json(ReviewLikeCount);
        }


        //public ActionResult UpdateLikes(int? ReviewID = 0, int? GlassID = 0)
        //{
        //    ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
        //    HttpCookie _UserID = Request.Cookies["_UserID"];
        //    try
        //    {
        //        int UserID = 0;
        //        if (_UserID.Value != null & _UserID.Value != "")
        //        {
        //            UserID = Convert.ToInt32(_UserID.Value);
        //            Session["UserID"] = Convert.ToInt32(_UserID.Value);
        //        }
        //        else
        //        {
        //            UserID = Convert.ToInt32(Session["UserID"]);
        //        }
        //        var ReviewLikeExist = dbEntities.tblReviewLikes.Where(a => a.Productid == GlassID && a.ReviewID == ReviewID && a.UserID == UserID);

        //        if (ReviewLikeExist.Count() > 0)
        //        {
        //            var ReviewLike = dbEntities.tblReviewLikes.Where(a => a.Productid == GlassID && a.ReviewID == ReviewID && a.UserID == UserID);
        //            dbEntities.tblReviewLikes.RemoveRange(ReviewLike);
        //            dbEntities.SaveChanges();
        //        }
        //        else if (ReviewLikeExist.Count() == 0)
        //        {

        //            tblReviewLike tbl = new tblReviewLike();
        //            tbl.UserID = UserID;
        //            tbl.ReviewID = ReviewID;
        //            tbl.Productid = GlassID;
        //            dbEntities.tblReviewLikes.Add(tbl);
        //            dbEntities.SaveChanges();
        //        }

        //        return RedirectToAction("Product_Details", "Products", new { Productid = GlassID });
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //    return RedirectToAction("Product_Details", "Products", new { Productid = GlassID });
        //}

        [HttpPost]
        public JsonResult SaveReview(int UserID, int GlassID, int Rating, string Review = "")
        {
            ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
            HttpCookie Namecookie = Request.Cookies["_UserName"];
            HttpCookie Imagecookie = Request.Cookies["_UserImage"];
            var latestreviews = dbEntities.tblReviews.Where(a => a.ReviewID == 0).FirstOrDefault();
            var imagereviewcount = 0;
            try
            {
                tblReview review = new tblReview();
                string MainRoot = "";
                review.UserID = UserID;
                review.GlassID = GlassID;
                review.Rating = Rating;
                int uid = UserID;
                tblUser us = new tblUser();
                us = dbEntities.tblUsers.Where(c => c.UserID == uid).FirstOrDefault();


                review.UserName = us.Firstname + " " + us.Lastname;
                review.Review = Review;
                review.CreatedDate = DateTime.Now;

                if (Imagecookie.Value != null && Imagecookie.Value != "")
                {
                    review.UserImage = Imagecookie.Value;
                    Session["UserImage"] = Imagecookie.Value;
                }
                else
                {

                    review.UserImage = Convert.ToString(Session["UserImage"]);
                }
                if (Request.Files.Count > 0)
                {

                    // Get all files from Request object
                    HttpFileCollectionBase files = Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {
                        //string path = AppDomain.CurrentDomain.BaseDirectory + “Uploads/”;
                        //string filename = Path.GetFileName(Request.Files[i].FileName);
                        HttpPostedFileBase file = files[i];
                        string ReviewFileName;
                        // Checking for Internet Explorer
                        if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                        {
                            string[] testfiles = file.FileName.Split(new char[] { '\\' });
                            ReviewFileName = testfiles[testfiles.Length - 1];
                            ReviewFileName = file.FileName;
                        }
                        else
                        {
                            ReviewFileName = file.FileName;

                        }
                        // Get the complete folder path and store the file inside it.
                        MainRoot = "/ProjectImages/Uploads/Reviews/" + review.UserID;

                        bool exists = System.IO.Directory.Exists(Server.MapPath(MainRoot));
                        if (!exists)
                            System.IO.Directory.CreateDirectory(Server.MapPath(MainRoot));



                        var ReviewServerFilePath = Path.Combine(Server.MapPath(MainRoot) + "\\" + ReviewFileName);

                        MainRoot = "/ProjectImages/Uploads/Reviews/" + review.UserID + "/" + ReviewFileName;

                        review.ReviewImage = MainRoot;
                        //Save Files to path
                        file.SaveAs(ReviewServerFilePath);
                    }


                }
                dbEntities.tblReviews.Add(review);
                dbEntities.SaveChanges();

                imagereviewcount = dbEntities.tblReviews.Where(a => a.GlassID == GlassID && a.ReviewImage != null).Count();
                latestreviews = dbEntities.tblReviews.Where(a => a.UserID == UserID && a.GlassID == GlassID).OrderByDescending(a => a.ReviewID).Take(1).FirstOrDefault();
                //return Json(latestreviews);

                var RatingSum = dbEntities.tblReviews.Where(a => a.GlassID == GlassID).Select(a => a.Rating).Sum();
                var RatingCount = dbEntities.tblReviews.Where(a => a.GlassID == GlassID).Count();
                RatingCount = RatingCount * 5;

                int AverageRating = 0;
                AverageRating = Convert.ToInt32((RatingSum * 5) / RatingCount);


                return Json(new { data = latestreviews, Totalimagereviews = imagereviewcount, Averagerating = AverageRating });
            }
            catch (Exception ex)
            {
                return Json(latestreviews);
            }

            return Json(new { data = latestreviews, Totalimagereviews = imagereviewcount });
        }


        [HttpGet]
        [Customexception]
        public ActionResult Deletecart(int? Cartid)
        {
            ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
            try
            {
                tblcart cp = dbEntities.tblcart.Find(Cartid);
                int userID = cp.Userid;
                dbEntities.tblcart.Remove(cp);
                dbEntities.SaveChanges();


                decimal grandtotalamount;
                //To update grand total in cart table
                double totalamount = dbEntities.tblcart.Where(c => c.Userid == cp.Userid).Select(c => c.TotalAmount).DefaultIfEmpty().Sum();
                grandtotalamount = Convert.ToDecimal(totalamount) + Convert.ToDecimal(totalamount / 100) * 5 + 9;
                (from c in dbEntities.tblcart where c.Userid == cp.Userid select c).ToList()
                                    .ForEach(x => x.GranTotal = Convert.ToDouble(grandtotalamount));
                dbEntities.SaveChanges();



                return RedirectToAction("MovetoOrdercart", "Products", new { id = userID });
            }
            catch (Exception ex)
            {

            }
            return RedirectToAction("MovetoOrdercart", "Products", new { Userid = 1 });
        }




        [HttpGet]
        [Customexception]
        public ActionResult Orderprocessing(int? Productid, int? VariationId, string Image, string size, int? USID, string Productcategory = "")
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                ViewBag.SPH = dbEntities.tblSizes.Where(x => x.Type == "SPH").ToList();
                ViewBag.CYL = dbEntities.tblSizes.Where(x => x.Type == "CYL").ToList();
                ViewBag.ADD = dbEntities.tblSizes.Where(x => x.Type == "ADD").ToList();
                ViewBag.PD = dbEntities.tblSizes.Where(x => x.Type == "PD").ToList();
                tblProduct pd = dbEntities.tblProducts.Find(Productid);
                ViewBag.Image = Image;
                ViewBag.size = size;
                string colors = dbEntities.tblVariation.Find(VariationId).Color1;

                ViewBag.hexacolor = dbEntities.tblColors.Where(a => a.hexacode == colors).Select(a => a.hexacode).FirstOrDefault();
                ViewBag.colorname = dbEntities.tblColors.Where(a => a.hexacode == colors).Select(a => a.colorname).FirstOrDefault();
                ViewBag.UserPrescription = dbEntities.tblUserPrescription.Where(a => a.UserID == USID).ToList();
                ViewBag.VariationId = VariationId;
                ViewBag.UserID = USID;

                if (pd.shape == null)
                {
                    pd.shape = "";

                }
                ViewBag.Shape = pd.shape;
                ViewBag.Productcategory = Productcategory;

                double FrameAWidth = Convert.ToDouble(dbEntities.tblVariation.Find(VariationId).FrameAWidth);
                string FrameDBBridger = dbEntities.tblVariation.Find(VariationId).FrameDBBridger;
                string FrameED = dbEntities.tblVariation.Find(VariationId).FrameED;

                ViewBag.FrameAWidth = FrameAWidth;
                ViewBag.FrameDBBridger = FrameDBBridger;
                ViewBag.FrameED = FrameED;
                return View(pd);
            }
            catch (Exception ex)
            {

            }
            return View();
        }

        [HttpPost]
        [Customexception]
        public ActionResult MovetoOrderprocessing(int? Productid, string color, string size)
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                return Json(new { url = Url.Action("Orderprocessing", "Products", new { Productid = Productid, color = color, size = size }) });
            }
            catch (Exception ex)
            {

            }
            return Json(new { url = Url.Action("Orderprocessing", "Products", new { Productid = Productid, color = color, size = size }) });
        }

        [HttpGet]
        [Customexception]
        public ActionResult MovetoOrdercart(int? id)
        {
            try
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
                id = Userid;
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                string cwhere = "";
                ViewBag.Usercartdetails = dbEntities.tblcart.Where(a => a.Userid == id).ToList();
                cwhere = "and ProductCategory = 'Accessory'";
                ViewBag.ProductList1 = dbEntities.Sp_Get_Product_List_Filter("Accessory", id, cwhere).ToList();
                ViewBag.Userid = id;
                List<tblOrder> order = dbEntities.tblOrder.Where(x => x.userID == id).ToList();
                int previousorders = 0;
                if (order != null)
                {
                    previousorders = order.Count;
                }
                ViewBag.previousorders = previousorders;
                return View();
            }
            catch (Exception ex)
            {

            }
            return View();
        }

        [HttpPost]
        [Customexception]
        public ActionResult Homeproductfilter(string Women, string Men, string[] ddlMaterial, string[] ddlAvailableSize, string[] ddlshape, string[] ddlcolor,
            string TopSeller, string NewArrivals)
        {
            ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
            string cwhere = "";
            var genderfilters = "";
            var materialfilters = "";
            var availablesizesfilters = "";
            var shapesfilters = "";
            var colorsfilters = "";
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
                //Gender Filter
                if (Women != "" && Men != "")
                {
                    Women = "'" + Women + "'";
                    Men = "'" + Men + "'";
                    cwhere += " and   Gender in ('UniSex'," + Women + "," + Men + ") ";
                }
                else if (Women != "" || Men != "")
                {
                    Women = "'" + Women + "'";
                    Men = "'" + Men + "'";
                    cwhere += " and   Gender in ('UniSex'," + Women + "," + Men + ") ";
                }

                else if (Women == "" && Men == "")
                {

                }

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

                //#Color
                if (ddlcolor != null)
                {
                    foreach (var item in ddlcolor)
                    {
                        colorsfilters += "'" + item + "'" + ",";
                    }
                    colorsfilters = colorsfilters.Remove(colorsfilters.Length - 1, 1);
                    cwhere += " and   V.Color1 in (" + colorsfilters + ") ";
                }



                if (TopSeller != "" && NewArrivals != "")
                {
                    TopSeller = "'" + TopSeller + "'";
                    NewArrivals = "'" + NewArrivals + "'";
                    cwhere += " and   Sticker in (" + TopSeller + "," + NewArrivals + ") ";
                }
                else if (TopSeller != "" || NewArrivals != "")
                {
                    TopSeller = "'" + TopSeller + "'";
                    NewArrivals = "'" + NewArrivals + "'";
                    cwhere += " and   Sticker in (" + TopSeller + "," + NewArrivals + ") ";
                }
                else if (TopSeller == "" && NewArrivals == "")
                {

                }

                ViewBag.ProductList = dbEntities.Sp_Get_Product_List_Filter("products", Userid, cwhere).ToList();
                return Json(ViewBag.ProductList, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

            }

            return Json(1, JsonRequestBehavior.AllowGet);

        }
        [HttpPost]
        public JsonResult Variationimages(int? variationid = 0)
        {
            List<tblvariationimages> vi = new List<tblvariationimages>();
            try
            {
                vi = dbEntities.tblvariationimages.Where(v => v.VariationID == variationid).ToList();
                return Json(vi, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json("Exception", JsonRequestBehavior.AllowGet);
            }
            return Json(vi, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [Customexception]
        public ActionResult HomePageProductFavourite(int? id = 0)
        {
            string color = "";
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
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
                    var ReviewLikeExist = dbEntities.tblFavourites.Where(a => a.ProductID == id && a.UserID == UserID);

                    if (ReviewLikeExist.Count() > 0)
                    {
                        var ReviewLike = dbEntities.tblFavourites.Where(a => a.ProductID == id && a.UserID == UserID);
                        dbEntities.tblFavourites.RemoveRange(ReviewLike);
                        dbEntities.SaveChanges();
                        color = "black";
                    }
                    else
                    {
                        tblFavourite tbl = new tblFavourite();
                        tbl.UserID = UserID;
                        tbl.ProductID = id;
                        tbl.CreateDate = DateTime.Now;
                        dbEntities.tblFavourites.Add(tbl);
                        dbEntities.SaveChanges();
                        color = "Red";

                    }

                }

                return Json(color, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {

            }
            return Json(color, JsonRequestBehavior.AllowGet);
        }

        [Customexception]
        public ActionResult AddtoCart(int ProductID, float price, string Name, string Image, string color, string size, int? type = 0, int UserID = 0)
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                tblProduct product = dbEntities.tblProducts.Find(ProductID);
                tblcart cart = new tblcart();
                cart.Userid = UserID;
                cart.GlassID = ProductID;
                cart.ProductImagePath = Image;
                cart.Price = price;
                cart.Title = Name;
                cart.UVProtection = "";
                cart.LensType = "";
                cart.VisionType = "";
                cart.Quantity = 1;
                cart.TotalAmount = price;
                cart.Productcategory = "Accessory";
                cart.Shippingamount = 9;
                cart.GranTotal = price + Convert.ToDouble(price * cart.Quantity) / 100 * 5 + 9;
                cart.Colour = color;
                cart.Size = size;
                dbEntities.tblcart.Add(cart);
                dbEntities.SaveChanges();

                decimal grandtotalamount;
                decimal newproductprice;

                //To update grand total in cart table
                //List<tblcart> usercartdata = new List<tblcart>();
                double totalamount = dbEntities.tblcart.Where(c => c.Userid == cart.Userid).Select(c => c.TotalAmount).DefaultIfEmpty().Sum();
                grandtotalamount = Convert.ToDecimal(totalamount) + Convert.ToDecimal(totalamount / 100) * 5 + 9;
                (from c in dbEntities.tblcart where c.Userid == cart.Userid select c).ToList()
                                    .ForEach(x => x.GranTotal = Convert.ToDouble(grandtotalamount));
                dbEntities.SaveChanges();





                return RedirectToAction("MovetoOrdercart", "Products", new { id = UserID });
            }
            catch (Exception ex)
            {

            }
            return RedirectToAction("MovetoOrdercart", "Products", new { id = UserID });
        }


        [HttpPost]
        public ActionResult OrderprocessingAddtoCart(tblcart cartdata, int? isusedsaveprescription = 0, int? Actioncalltype = 0, int? noprescription = 0)
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();

                string MainRoot = "";
                string pdimage = "";
                string prescriptionimage = "";
                int Userid = 0;

                HttpCookie _UserID = Request.Cookies["_UserID"];
                if (_UserID.Value != null & _UserID.Value != "")
                {
                    Userid = Convert.ToInt32(_UserID.Value);
                    Session["UserID"] = Convert.ToInt32(_UserID.Value);
                }
                else
                {
                    Userid = cartdata.Userid;
                    Session["UserID"] = Userid;
                    Userid = Convert.ToInt32(Session["UserID"]);
                }


                if (cartdata.PDImage != "" && cartdata.PrescriptionImage != null)
                {

                    if (cartdata.PDImage.Contains("ProjectImages"))
                    {

                    }
                    else
                    {
                        //Convert Base64 string to Byte Array.
                        byte[] bytes = Convert.FromBase64String(cartdata.PDImage);
                        //Save the Byte Array as Image File.

                        //create directory for image if not exists
                        MainRoot = "/ProjectImages/Prescription/" + cartdata.GlassID + "/";
                        bool exists = System.IO.Directory.Exists(Server.MapPath(MainRoot));
                        if (!exists)
                            System.IO.Directory.CreateDirectory(Server.MapPath(MainRoot));

                        pdimage = string.Format("/ProjectImages/Prescription/" + cartdata.GlassID + "/{0}.png", Userid + "-PDImage-" + cartdata.GlassID);

                        System.IO.File.WriteAllBytes(Server.MapPath(pdimage), bytes);
                    }
                    cartdata.PDImage = pdimage;
                }







                if (cartdata.PrescriptionImage != "" && cartdata.PrescriptionImage != null)
                {

                    if (cartdata.PrescriptionImage.Contains("ProjectImages"))
                    {

                    }
                    else
                    {
                        //Convert Base64 string to Byte Array.
                        byte[] bytes = Convert.FromBase64String(cartdata.PrescriptionImage);
                        //Save the Byte Array as Image File.
                        MainRoot = "/ProjectImages/Prescription/" + cartdata.GlassID + "/";
                        bool exists = System.IO.Directory.Exists(Server.MapPath(MainRoot));
                        if (!exists)
                            System.IO.Directory.CreateDirectory(Server.MapPath(MainRoot));

                        prescriptionimage = string.Format("/ProjectImages/Prescription/" + cartdata.GlassID + "/{0}.png", Userid + "-PrescriptionImage-" + cartdata.GlassID);
                        System.IO.File.WriteAllBytes(Server.MapPath(prescriptionimage), bytes);
                    }

                    
                    cartdata.PrescriptionImage = prescriptionimage;
                }

                


                tblcart cart = new tblcart();
                dbEntities.tblcart.Add(cartdata);
                dbEntities.SaveChanges();

                decimal grandtotalamount;
                //To update grand total in cart table
                double totalamount = dbEntities.tblcart.Where(c => c.Userid == cartdata.Userid).Select(c => c.TotalAmount).DefaultIfEmpty().Sum();
                grandtotalamount = Convert.ToDecimal(totalamount) + Convert.ToDecimal(totalamount / 100) * 5 + 9;
                (from c in dbEntities.tblcart where c.Userid == cartdata.Userid select c).ToList()
                                    .ForEach(x => x.GranTotal = Convert.ToDouble(grandtotalamount));
                dbEntities.SaveChanges();

                //To update grand total in cart table
                //List<tblcart> usercartdata = new List<tblcart>();
                //usercartdata = dbEntities.tblcart.Where(c => c.Userid == cartdata.Userid).OrderBy(x => x.Cartid).Take(1).ToList();
                //decimal grandtotalamount;
                //decimal newproductprice;
                // grandtotalamount = Convert.ToDecimal(usercartdata[0].GranTotal);
                //// 5 is tax% of total amount
                ////9 is shipping charges
                //if (grandtotalamount == 0)
                //{
                //    newproductprice = Convert.ToDecimal(cartdata.TotalAmount + (cartdata.TotalAmount) / 100 * 5 + 9);
                //    grandtotalamount = newproductprice;   
                //}
                //else
                //{
                //    newproductprice = Convert.ToDecimal(cartdata.TotalAmount + (cartdata.TotalAmount) / 100 * 5 + 9);
                //    grandtotalamount = grandtotalamount + newproductprice;
                //}



                //(from c in dbEntities.tblcart where c.Userid == cartdata.Userid select c).ToList()
                //                        .ForEach(x => x.GranTotal = Convert.ToDouble(grandtotalamount));
                //dbEntities.SaveChanges();



                if (cartdata.Prescriptionid == 0 && noprescription == 0)
                {
                    tblUserPrescription up = new tblUserPrescription();
                    up.ProductID = cartdata.GlassID;
                    up.OrderID = 0;

                    up.r_sph = cartdata.r_sph;
                    up.r_cyl = cartdata.r_cyl;
                    up.r_axis = cartdata.r_axis;
                    up.r_add = cartdata.r_add;
                    up.l_sph = cartdata.l_sph;
                    up.l_cyl = cartdata.l_cyl;
                    up.l_axis = cartdata.l_axis;
                    up.l_add = cartdata.l_add;
                    up.lensType = cartdata.LensType;
                    up.quantity = 1;
                    up.Fname = cartdata.Fname;
                    up.Lname = cartdata.Lname;
                    up.prescription = cartdata.prescription;
                    up.prescriptionDate = cartdata.prescriptionDate;
                    up.PD = cartdata.PD;
                    up.UserID = cartdata.Userid;
                    up.PDImage = cartdata.PDImage;
                    up.PrescriptionImage = cartdata.PrescriptionImage;
                    up.CreatedDate = DateTime.Now;
                    up.Dualpd = cartdata.Dualpd;
                    up.Rightpd = cartdata.Rightpd;
                    up.Segmentheight = cartdata.Segmentheight;
                    dbEntities.tblUserPrescription.Add(up);
                    dbEntities.SaveChanges();

                }


                return Json(new { url = Url.Action("MovetoOrdercart", "Products", new { id = cartdata.Userid }) });
            }
            catch (Exception ex)
            {

            }
            return Json(new { url = Url.Action("MovetoOrdercart", "Products", new { Userid = cartdata.Userid }) });
        }


        [HttpPost]
        public ActionResult MoveprocessingtoOrdercart(tblcart cart)
        {
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                dbEntities.tblcart.Add(cart);
                dbEntities.SaveChanges();
                int Userid = cart.Userid;

                return Json(new { url = Url.Action("MovetoOrdercart", "Products", new { Userid = Userid }) });
            }
            catch (Exception ex)
            {

            }
            return Json(new { url = Url.Action("Orderprocessing", "Products", new { Usercartid = 1 }) });
        }


        [HttpPost]
        public ActionResult Applycoupon(string Couponcode, int Userid, string applytype, double Subtotalvalue)
        {
            double discountamount = 0;
            tblCoupon cp = new tblCoupon();
            try
            {
                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                Couponcode = Couponcode.Trim();
                cp = dbEntities.tblCoupons.Where(a => a.CouponCode == Couponcode && a.CouponStatus == "Active").FirstOrDefault();

                var usercartitems = dbEntities.tblcart.Where(x => x.Userid == Userid).ToList();
                if (cp == null)
                {
                    if (applytype == "R")

                    {
                        usercartitems.ForEach(a =>
                        {
                            a.CouponID = 0;
                            a.CouponCode = "";
                            a.Discountamount = 0;
                            a.Discount = discountamount;
                        });
                    }

                    dbEntities.SaveChanges();

                    return Json(new { amount = 0, type = 0 }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    //A means apply coupon
                    if (applytype == "A")
                    {
                        if (cp.DiscountType == "1")
                        {
                            discountamount = Convert.ToDouble(Subtotalvalue) / 100 * Convert.ToDouble(cp.Discount);
                            usercartitems.ForEach(a =>
                            {
                                a.CouponID = cp.CouponID;
                                a.CouponCode = cp.CouponCode;
                                a.Discount = Convert.ToDouble(cp.Discount);
                                a.Discountamount = discountamount;
                            });
                        }
                        else
                        {
                            discountamount =  Convert.ToDouble(cp.Discount);
                            usercartitems.ForEach(a =>
                            {
                                a.CouponID = cp.CouponID;
                                a.CouponCode = cp.CouponCode;
                                a.Discount = 0;
                                a.Discountamount = discountamount;
                            });
                        }
                      
                    }
                    //R means reverse coupon
                    else if (applytype == "R")

                    {
                        usercartitems.ForEach(a =>
                        {
                            a.CouponID = 0;
                            a.CouponCode = "";
                            a.Discount = 0;
                            a.Discountamount = discountamount;
                        });
                    }

                    dbEntities.SaveChanges();
                    return Json(new { amount = cp.Discount, type = cp.DiscountType }, JsonRequestBehavior.AllowGet);
                }


            }
            catch (Exception ex)
            {
                return Json(new { cp, data = ex.Message });
            }

        }


        [HttpPost]
        public ActionResult Updatecart(string updatetype, int? cartid, int? quantity, int? subtotal, double TaxAmount, double Discount, double Shippingamount, double ordertotal)
        {
            tblcart cp = new tblcart();
            try
            {

                ViewBag.ProductVirtualList = dbEntities.Sp_Get_Product_List(0, "").ToList();
                cp = dbEntities.tblcart.Find(cartid);

                if (updatetype == "EL")
                {
                    cp.LensType = "Enhanced";
                }
                if (updatetype == "SL")
                {
                    cp.LensType = "Standard";
                }
                if (updatetype == "RE")
                {
                    cp.VisionType = "Reading";
                }
                if (updatetype == "DI")
                {
                    cp.VisionType = "Distance";
                }

                //if premium is selected or unselected
                if (updatetype == "PC")
                {
                    if (cp.LensType == "Premium Coatings")
                    {
                        cp.LensType = "Standard";
                    }
                    else
                    {
                        cp.LensType = "Premium Coatings";
                    }
                }

                if (updatetype == "UV")
                {
                    if (cp.UVProtection == "on")
                    {
                        cp.UVProtection = "off";
                    }
                    else if (cp.UVProtection == "off")
                    {
                        cp.UVProtection = "on";
                    }

                }

                cp.Quantity = Convert.ToInt32(quantity);
                cp.TotalAmount = Convert.ToDouble(subtotal);

                cp.Shippingamount = Shippingamount;
                cp.TaxAmount = TaxAmount;
                cp.Discount = Discount;
                cp.GranTotal = ordertotal;
                dbEntities.SaveChanges();


                //To update grand total in cart table


                decimal grandtotalamount;
                //To update grand total in cart table
                double totalamount = dbEntities.tblcart.Where(c => c.Userid == cp.Userid).Select(c => c.TotalAmount).DefaultIfEmpty().Sum();
                grandtotalamount = Convert.ToDecimal(totalamount) + Convert.ToDecimal(totalamount / 100) * 5 + 9;
                (from c in dbEntities.tblcart where c.Userid == cp.Userid select c).ToList()
                                    .ForEach(x => x.GranTotal = Convert.ToDouble(grandtotalamount));
                dbEntities.SaveChanges();

                //List<tblcart> usercartdata = new List<tblcart>();
                //usercartdata = dbEntities.tblcart.Where(c => c.Userid == cp.Userid).OrderBy(x => x.Cartid).Take(1).ToList();
                //decimal grandtotalamount;
                //decimal newproductprice;
                //grandtotalamount = Convert.ToDecimal(usercartdata[0].GranTotal);
                //// 5 is tax% of total amount
                ////9 is shipping charges
                //if (grandtotalamount == 0)
                //{
                //    newproductprice = Convert.ToDecimal(cp.TotalAmount + (cp.TotalAmount) / 100 * 5 + 9);
                //    grandtotalamount = newproductprice;
                //}
                //else
                //{
                //    newproductprice = Convert.ToDecimal(cp.TotalAmount + (cp.TotalAmount) / 100 * 5 + 9);
                //    grandtotalamount = grandtotalamount + newproductprice;
                //}



                //(from c in dbEntities.tblcart where c.Userid == cp.Userid select c).ToList()
                //                        .ForEach(x => x.GranTotal = Convert.ToDouble(grandtotalamount));
                //dbEntities.SaveChanges();

                return Json("1", JsonRequestBehavior.AllowGet);



            }
            catch (Exception ex)
            {
                return Json(new { cp, data = ex.Message });
            }

        }




        //comment backup bilal
        //public ActionResult UpdateLikes(int? ReviewID = 0, int? GlassID = 0)
        //{
        //    try
        //    {
        //        var ReviewLikeExist = dbEntities.tblReviewLikes.Where(a => a.Productid == GlassID && a.ReviewID == ReviewID);

        //        if (ReviewLikeExist.Count() > 0)
        //        {
        //            var ReviewLike = dbEntities.tblReviewLikes.Where(a => a.Productid == GlassID && a.ReviewID == ReviewID);
        //            dbEntities.tblReviewLikes.RemoveRange(ReviewLike);
        //            dbEntities.SaveChanges();
        //        }
        //        else if (ReviewLikeExist.Count() == 0)
        //        {
        //            tblReviewLike tbl = new tblReviewLike();
        //            tbl.UserID = 1;
        //            tbl.ReviewID = ReviewID;
        //            tbl.Productid = GlassID;
        //            dbEntities.tblReviewLikes.Add(tbl);
        //            dbEntities.SaveChanges();
        //        }

        //        return RedirectToAction("Product_Details", "Products", new { Productid = GlassID });
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //    return RedirectToAction("Product_Details", "Products", new { Productid = GlassID });
        //}

        //[HttpPost]
        //public ActionResult SaveReview(string UserID, string GlassID, string Rating, HttpPostedFileBase[] ReviewImage, string Review = "")
        //{
        //    try
        //    {
        //        tblReview review = new tblReview();
        //        string MainRoot = "";
        //        review.UserID = 1;
        //        review.GlassID = 2;
        //        review.Rating = Convert.ToInt32(Rating);
        //        review.Review = Review;
        //        review.CreatedDate = DateTime.Now;




        //        foreach (HttpPostedFileBase image in ReviewImage)
        //        {

        //            if (image != null)
        //            {


        //                var ReviewFileName = Path.GetFileName(image.FileName);
        //                MainRoot = "/Uploads/Reviews/" + review.UserID;

        //                bool exists = System.IO.Directory.Exists(Server.MapPath(MainRoot));
        //                if (!exists)
        //                    System.IO.Directory.CreateDirectory(Server.MapPath(MainRoot));



        //                var ReviewServerFilePath = Path.Combine(Server.MapPath(MainRoot) + "\\" + ReviewFileName);

        //                MainRoot = "/Uploads/Reviews/" + review.UserID + "/" + ReviewFileName;

        //                review.ReviewImage = MainRoot;
        //                //Save Files to path
        //                image.SaveAs(ReviewServerFilePath);

        //            }
        //        }


        //        dbEntities.tblReviews.Add(review);
        //        dbEntities.SaveChanges();
        //        return RedirectToAction("Product_Details", "Products", new { Productid = 1 });
        //    }
        //    catch (Exception ex)
        //    {
        //        ViewBag.Error = "Exception Occur While Saving Broker " + ex.Message;
        //    }

        //    return RedirectToAction("Product_Details", "Products", new { Productid = 1 });
        //}

    }
}