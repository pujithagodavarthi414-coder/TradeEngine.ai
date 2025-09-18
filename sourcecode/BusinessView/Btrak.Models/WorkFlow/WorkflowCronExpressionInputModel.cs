using System;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkflowCronExpressionInputModel
    {
        public Guid? CronExpressionId { get; set; }

        public string CronExpressionName { get; set; }

        public string CronExpression { get; set; }

        public string CronRadio { get; set; }

        public string DataJson { get; set; }

        public string CronExpressionDescription { get; set; }

        public Guid? WorkflowId { get; set; }

        public bool? IsArchived { get; set; }

        public Guid? WorkflowTypeId { get; set; }
        public int? JobId { get; set; }

        public Guid? UserId { get; set; }

        public Guid? NewCronExpressionId { get; set; }

        public string WorkflowName { get; set; }

        public string WorkflowXml { get; set; }
        public Guid? ResponsibleUserId { get; set; }
        public string Timezone { get; set; }
        public int OffsetMinutes { get; set; }

        public Guid? FormId { get; set; }
    }
}