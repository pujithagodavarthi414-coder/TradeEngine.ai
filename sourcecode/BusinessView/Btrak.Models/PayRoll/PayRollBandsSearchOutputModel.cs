using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollBandsSearchOutputModel
    {
        public Guid? PayRollBandId { get; set; }
        public string Name { get; set; }
        public decimal? FromRange { get; set; }
        public decimal? ToRange { get; set; }
        public decimal? Percentage { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool IsArchived { get; set; }
        public Guid? ParentId { get; set; }
        public string ParentName { get; set; }
        public string ModifiedFromRange { get; set; }
        public string ModifiedToRange { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public string PayRollComponentName { get; set; }
        public int? MinAge { get; set; }
        public int? MaxAge { get; set; }
        public int? Order { get; set; }
        public bool? ForMale { get; set; }
        public bool? ForFemale { get; set; }
        public bool? Handicapped { get; set; }
        public bool? IsMarried { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
