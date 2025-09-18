using System;

namespace BusinessView.Api.Models.OffersModel
{
    public class OffersDto
    {
        public int Id { get; set; }
        public int AdminId { get; set; }
        public int EmployeeId { get; set; }
        public Nullable<decimal> OfferAmount { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? CreatedOn { get; set; }
        public bool? IsOfferApplicable { get; set; }
    }
}