using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class EmployeeLanguagesInputModel : InputModelBase
    {
        public EmployeeLanguagesInputModel() : base(InputTypeGuidConstants.EmployeeSkillInputCommandTypeGuid)
        {
        }
         
        public Guid? EmployeeLanguageId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? LanguageId { get; set; }
        public Guid? FluencyId { get; set; }
        public Guid? CompetencyId { get; set; }
        public string Comments { get; set; }
        public bool? IsArchived { get; set; }
        public bool CanRead { get; set; }
        public bool CanWrite { get; set; }
        public bool CanSpeak { get; set; }
        public Guid? OperationsPerformedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeLanguageId  = " + EmployeeLanguageId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", LanguageId = " + LanguageId);
            stringBuilder.Append(", FluencyId = " + FluencyId);
            stringBuilder.Append(", CanRead = " + CanRead);
            stringBuilder.Append(", CanWrite = " + CanWrite);
            stringBuilder.Append(", CanSpeak = " + CanSpeak);
            stringBuilder.Append(", CompetencyId = " + CompetencyId);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
