using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    [FilterConfig.NoDirectAccess]
    [FilterConfig.AuthorizeActionFilter]
    public class PromotionController : Controller
    {
        OlaGlassesEntities dbEntity = new OlaGlassesEntities();
        // GET: Promotion

        [Customexception]
        public ActionResult Index(string message)
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



            ViewBag.message = message;
            List<tblpromotionoffer> promotions = new List<tblpromotionoffer>();
            promotions = dbEntity.tblpromotionoffer.ToList();
            ViewBag.promotions = promotions;
            return View();
        }

        [Customexception]
        public ActionResult Edit(int? id)
        {
            tblpromotionoffer promotion = new tblpromotionoffer();
            try
            {

                if (id > 0)
                {
                    promotion = dbEntity.tblpromotionoffer.Find(id);

                }
                else
                {
                    promotion.colorcode = "";
                    promotion.colorname = "";
                    promotion.description = "";
                    promotion.isActive = 0;


                }
                ViewBag.Color = "Green";
                ViewBag.Error = "";
                ViewBag.colorlist = dbEntity.tblColors.ToList();
                return View(promotion);

            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                ViewBag.Color = "Red";

            }
            return View(promotion);
        }


        [HttpPost]
        [Customexception]
        public ActionResult Edit(tblpromotionoffer promotion)
        {
            if (promotion.Promotionid > 0)
            {
                if (promotion.isActive == 1)
                {
                    if (dbEntity.tblpromotionoffer.Where(x => x.isActive == 1).Count() == 0)
                    {
                        return RedirectToAction("Index", new { message = "Only one promotion should be active at a time." });
                    }
                }

                dbEntity.Entry(promotion).State = EntityState.Modified;
                dbEntity.SaveChanges();
                return RedirectToAction("Index", new { message = "Record Updated Successfully" });

            }
            else
            {
                dbEntity.tblpromotionoffer.Add(promotion);
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

                tblpromotionoffer make = dbEntity.tblpromotionoffer.Find(id);
                if (make != null)
                {
                    dbEntity.tblpromotionoffer.Remove(make);
                    dbEntity.SaveChanges();
                }


                return RedirectToAction("Index", new { message = "Record Deleted Successfully" });
            }
            catch (Exception)
            {

                throw;
            }

        }

    }
}