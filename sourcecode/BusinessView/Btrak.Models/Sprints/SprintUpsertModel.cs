using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Sprints
{
    public class SprintUpsertModel
    {
        public Guid? SprintId { get; set; }
        public Guid? ProjectId { get; set; }
        public string SprintName { get; set; }
        public DateTime? SprintStartDate { get; set; }
        public DateTime? SprintEndDate { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Description { get; set; }
        public bool? IsReplan { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public string Version { get; set; }
        public string TimeZone { get; set; }
        public Guid? SprintResponsiblePersonId { get; set; }
        public bool? EditSprint { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", SprintId = " + SprintId);
            stringBuilder.Append(", SprintName = " + SprintName);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            stringBuilder.Append(", SprintStartDate = " + SprintStartDate);
            stringBuilder.Append(", SprintEndDate = " + SprintEndDate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", Description = " + Description);
            return stringBuilder.ToString();
        }
    }
}
