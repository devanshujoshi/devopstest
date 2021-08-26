using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using StoreAppView.Models;

namespace StoreAppView.Controllers
{
    public class ProductController : Controller
    {
        private const double V = 90.5;

        // GET: Product
        public ActionResult ViewProduct()
        {
            Product product = new Product()
            {
                Id = 1001,
                Name = "Carpet",
                Price = V
            };
            return View(product);
        }
    }
}