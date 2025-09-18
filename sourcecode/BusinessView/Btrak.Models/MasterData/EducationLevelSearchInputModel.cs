using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class EducationLevelSearchInputModel: SearchCriteriaInputModelBase
    {
        public EducationLevelSearchInputModel() : base(InputTypeGuidConstants.GetEducationLevel)
        {
        }

        public Guid? EducationLevelId { get; set; }
        public string EducationLevelName { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EducationLevelId = " + EducationLevelId);
            stringBuilder.Append("EducationLevelName = " + EducationLevelName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}