using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class EducationLevelSearchOutputModel
    {
        public Guid? EducationLevelId { get; set; }
        public string EducationLevelName { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EducationLevelId = " + EducationLevelId);
            stringBuilder.Append(", EducationLevelName = " + EducationLevelName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
