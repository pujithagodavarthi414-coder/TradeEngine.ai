using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BusinessView.Api.Models.FoodManagementModel
{
    public class FoodItemsDto
    {
        public int Id { get; set; }
        public string ItemName { get; set; }
        public decimal? Price { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? CreatedOn { get; set; }
    }
}