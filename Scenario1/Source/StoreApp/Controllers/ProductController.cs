using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using StoreApp.Models;

namespace StoreApp.Controllers
{
    
    public class ProductController : ApiController
    {
        List<Product> products = new List<Product>()
        {
            new Product { Id = 1, Name = "Tomato Soup", Price = 1 },
            new Product { Id = 2, Name = "Yo-yo", Price = 3.75M },
            new Product { Id = 3, Name = "Hammer", Price = 16.99M }
        };

        public ProductController() { }

        public ProductController(List<Product> products)
        {
            this.products = products;
        }

        [HttpGet()]
        public IEnumerable<Product> GetAllProducts()
        {
            return products;
        }

        public async Task<IEnumerable<Product>> GetAllProductsAsync()
        {
            return await Task.FromResult(GetAllProducts());
        }

        public IHttpActionResult GetProduct(int id)
        {
            var product = products.FirstOrDefault((p) => p.Id == id);
            if (product == null)
            {
                return NotFound();
            }
            return Ok(product);
        }

        public async Task<IHttpActionResult> GetProductAsync(int id)
        {
            return await Task.FromResult(GetProduct(id));
        }
    }
}