using System;

namespace Btrak.Models.CustomApplication
{
    public class CustomApplicationKeySearchOutputModel
    {
        public Guid? CustomApplicationKeyId { get; set; }
        public string Key { get; set; }
        public Guid? CustomApplicationId  { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsPrivate { get; set; }
        public bool? IsTag { get; set; }
        public bool? IsTrendsEnable { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int? VersionNumber { get; set; }
        public DateTime? AsAtInActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        
    }
}
