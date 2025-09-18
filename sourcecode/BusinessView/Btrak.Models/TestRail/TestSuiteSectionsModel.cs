using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class TestSuiteSectionsModel
    {
        public Guid? SectionsId { get; set; }

        public string SectionName { get; set; }

        public Guid? ParentSectionId { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public Guid? CreatedByUserId { get; set; }

        public byte[] TimeStamp { get; set; }

        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SectionsId = " + SectionsId);
            stringBuilder.Append(", SectionName = " + SectionName);
            stringBuilder.Append(", ParentSectionId = " + ParentSectionId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
