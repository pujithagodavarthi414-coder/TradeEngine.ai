using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class SectionDropdownModel
    {
        public Guid? Id { get; set; }

        public string SectionName { get; set; }

        public bool IsSection { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", SectionName = " + SectionName);
            stringBuilder.Append(", IsSection = " + IsSection);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
