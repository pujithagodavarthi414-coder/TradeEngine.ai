using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class IndustryModuleOutputModel
    {
        public Guid? IndustryModuleId { get; set; }
        public Guid? IndustryId { get; set; }
        public Guid? ModuleId { get; set; }
        public Guid? OriginalId { get; set; }
        public byte[] TimeStamp { get; set; }
        public string IndustryName { get; set; }
        public string ModuleName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IndustryModuleId   = " + IndustryModuleId);
            stringBuilder.Append(", IndustryId  = " + IndustryId);
            stringBuilder.Append(", ModuleId  = " + ModuleId);
            stringBuilder.Append(", TimeStamp   = " + TimeStamp);
            stringBuilder.Append(", IndustryName  = " + IndustryName);
            stringBuilder.Append(", ModuleName   = " + ModuleName);
            stringBuilder.Append(", OriginalId  = " + OriginalId);
            stringBuilder.Append(", CreatedDateTime   = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId  = " + CreatedByUserId);
            stringBuilder.Append(", TotalCount  = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
