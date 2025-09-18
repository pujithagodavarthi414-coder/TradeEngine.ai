using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class EducationLevelUpsertModel : InputModelBase
    {
        public EducationLevelUpsertModel() : base(InputTypeGuidConstants.EducationLevelInputCommandTypeGuid)
        {
        }

        public Guid? EducationLevelId { get; set; }
        public string EducationLevelName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EducationLevelId = " + EducationLevelId);
            stringBuilder.Append("EducationLevelName = " + EducationLevelName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append("TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }

    }
}