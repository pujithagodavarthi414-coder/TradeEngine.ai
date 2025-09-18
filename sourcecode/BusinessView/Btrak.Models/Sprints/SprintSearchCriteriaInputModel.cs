using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Sprints
{
    public class SprintSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SprintSearchCriteriaInputModel() : base(InputTypeGuidConstants.SprintSearchCriteriaInputCommandTypeGuid)
        {

        }
        public Guid? SprintId { get; set; }
        public string SprintUniqueNumber { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? SprintName { get; set; }
        public bool? IsBacklog { get; set; }
        public bool? IsActiveSprints { get; set; }
        public bool? IsReplan { get; set; }
        public bool? IsComplete { get; set; }
        public bool? AllSprints { get; set; }
        public string SprintIds { get; set; }
        public string SprintIdsXml { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", SprintId = " + SprintId);
            stringBuilder.Append(", IsBacklog = " + IsBacklog);
            return stringBuilder.ToString();
        }
    }
}
