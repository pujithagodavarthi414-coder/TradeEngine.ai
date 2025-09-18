using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Audit
{
    public class AuditConductTimelineOutputModel
    {
        public Guid AuditId { get; set; }
        public string AuditName { get; set; }
        public Guid AuditConductId { get; set; }
        public string AuditConductName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int ConductScore { get; set; }
        public int TotalQuestions { get; set; }
        public int TotalAnswers { get; set; }
        public int TotalValidAnswers { get; set; }
        public string CreatedByUserName { get; set; }
        public Boolean IsCompleted { get; set; }
        public DateTime Deadline { get; set; }
        public DateTime CreatedDatetime { get; set; }
        public Boolean IsRecurring { get; set; }
        public string CronExpression { get; set; }
        public int InboundPercent { get; set; }
        public int OutboundPercent { get; set; }
        public DateTime? FirstAnswerdDateTime { get; set; }
        public DateTime? LastAnswerdDateTime { get; set; }
        public DateTime? CronStartDate { get; set; }
        public DateTime? CronEndDate { get; set; }
        public DateTime? ScheduleStartDate { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public int? SpanInYears { get; set; }
        public int? SpanInMonths { get; set; }
        public int? SpanInDays { get; set; }
        public Guid? ProjectId { get; set; }
    }
}
