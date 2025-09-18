using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class JobCategorySearchInputModel : SearchCriteriaInputModelBase
    {
        public JobCategorySearchInputModel() : base(InputTypeGuidConstants.GetEducationLevel)
        {
        }

        public Guid? JobCategoryId { get; set; }
        public string JobCategoryName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("JobCategoryId = " + JobCategoryId);
            stringBuilder.Append("JobCategoryName = " + JobCategoryName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}