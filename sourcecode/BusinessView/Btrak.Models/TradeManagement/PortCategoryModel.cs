using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.TradeManagement
{
    public class PortCategoryModel
    {
        public Guid? Id { get; set; }
        public Guid? CompanyId { get; set; }
        public string Name { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" Id = " + Id);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }

    public class PortCategorySearchInputModel : SearchCriteriaInputModelBase
    {
        public PortCategorySearchInputModel() : base(InputTypeGuidConstants.PortCategoryInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" Id = " + Id);
            return stringBuilder.ToString();
        }
    }
}
