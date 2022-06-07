using Olaglasses.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Olaglasses.Controllers
{
    public class OrdersController : Controller
    {
        private OlaGlassesEntities dbEntities = new OlaGlassesEntities();
        // GET: Orders
        public ActionResult shippinglabel(int id=0)
        {

            List<spgetorderDetails_Result3> spgetorderDetails = dbEntities.spgetorderDetails(id).ToList();
            ViewBag.OrderDetails = spgetorderDetails;
            return View();
        }
    }
}