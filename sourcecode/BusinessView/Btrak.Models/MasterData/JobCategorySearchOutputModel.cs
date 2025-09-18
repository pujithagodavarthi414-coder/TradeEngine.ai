using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class JobCategorySearchOutputModel
    {
        public Guid? JobCategoryId { get; set; }        
        public string JobCategoryName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }
        public int? NoticePeriodInMonths { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("JobCategoryId = " + JobCategoryId);
            stringBuilder.Append("JobCategoryName = " + JobCategoryName);
            stringBuilder.Append("CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}