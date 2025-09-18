using System;

namespace Btrak.Models.MasterData
{
    public class CompanySettingsSearchOutputModel
    { 
        public Guid? CompanySettingsId { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public Guid? CompanyId { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public bool? IsVisible { get; set; }
    }

    public class DocumentSettingsSearchOutputModel
    {
        public Guid? CompanySettingsId { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public Guid? CompanyId { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public bool? IsVisible { get; set; }
        public double SizeUsed { get; set; }
        public double SizeAllocated { get; set; }
        public double ExtendedSize { get; set; }
        public bool? IsSizeLimitExceeded { get; set; }
        public bool? IsToRestrictUpload { get; set; }
    }
}