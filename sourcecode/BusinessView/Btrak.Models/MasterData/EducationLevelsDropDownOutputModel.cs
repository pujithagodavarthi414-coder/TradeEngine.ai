using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class EducationLevelsDropDownOutputModel
    {
        public Guid? EducationLevelId { get; set; }
        public string EducationLevelName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EducationLevelId = " + EducationLevelId);
            stringBuilder.Append(", EducationLevelName = " + EducationLevelName);
            return stringBuilder.ToString();
        }
    }
}