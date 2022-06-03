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
    public class CouponsController : Controller
    {
        // GET: Coupons
        OlaGlassesEntities dbEntity = new OlaGlassesEntities();
        [Customexception]
        public ActionResult Index(string message)
        {

            tblCoupon coupon = dbEntity.tblCoupons.Where(x => x.CouponStatus == "Active").FirstOrDefault();
            

            ViewBag.message = message;
            List<tblCoupon> coupons = new List<tblCoupon>();
            coupons = dbEntity.tblCoupons.ToList();
            ViewBag.couponsList = coupons;
            return View();
        }
        [Customexception]
        public ActionResult Create(int? id)
        {
            tblCoupon product = new tblCoupon();
            try
            {
                
                if (id > 0)
                {
                    product = dbEntity.tblCoupons.Find(id);

                }
                else
                {
                    product.CouponCode = "";
                    product.CouponColor = "";
                    product.CouponLink = "";
                    product.CouponStatus = "";
                    product.Discount = 0;
                    product.Description = "";


                }
                ViewBag.Color = "Green";
                ViewBag.Error = "";
                ViewBag.colorlist = dbEntity.tblColors.ToList();
                return View(product);
             





            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                ViewBag.Color = "Red";

            }
            return View(product);
        }
        [HttpPost]
        [Customexception]
        public ActionResult Create(tblCoupon product)
        {
             if (product.CouponID > 0)
            {
                dbEntity.Entry(product).State = EntityState.Modified;
                dbEntity.SaveChanges();
                return RedirectToAction("Index", new { message = "Record Updated Successfully" });

            }
            else
            {
                dbEntity.tblCoupons.Add(product);
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

                tblCoupon make = dbEntity.tblCoupons.Find(id);
                if (make != null)
                {
                    dbEntity.tblCoupons.Remove(make);
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