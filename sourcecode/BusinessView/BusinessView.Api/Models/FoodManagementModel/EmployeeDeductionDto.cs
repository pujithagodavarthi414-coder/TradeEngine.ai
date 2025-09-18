using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BusinessView.Api.Models.FoodManagementModel
{
    public class EmployeeDeductionDto
    {
        public int Id { get; set; }
        public int? UserId { get; set; }
        public int? AdminId { get; set; }
        public decimal? Amount { get; set; }
        public int? CretedBy { get; set; }
        public DateTime? CretedOn { get; set; }
    }
}