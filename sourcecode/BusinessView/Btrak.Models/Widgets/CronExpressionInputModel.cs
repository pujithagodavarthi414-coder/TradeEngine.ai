using Btrak.Models.ComplianceAudit;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class CronExpressionInputModel : InputModelBase
    {
        public CronExpressionInputModel() : base(InputTypeGuidConstants.CustomWidgetUpsertCronExpressionTypeGuid)
        {
        }
        public Guid? CronExpressionId { get; set; }

        public string CronExpressionName { get; set; }

        public string CronExpression { get; set; }

        public string CronExpressionDescription { get; set; }

        public Guid? CustomWidgetId { get; set; }

        public bool? IsArchived { get; set; }
        public bool? IsForTimeSheet { get; set; }

        public string SelectedCharts { get; set; }

        public string SelectedChartName { get; set; }

        public string TemplateType { get; set; }

        public List<FileBytesModel> FileBytes { get; set; }

        public List<FileDetailsModel> FileUrl { get; set; }

        public bool? RunNow { get; set; }

        public bool? IsRecurringWorkItem { get; set; }

        public string TemplateUrl { get; set; }

        public int? JobId { get; set; }

        public string ChartsUrls { get; set; }

        public Guid? UserId { get; set; }

        public Guid? NewCronExpressionId { get; set; }

        public string CustomAppName { get; set; }

        public DateTime? ScheduleEndDate { get; set; }

        public bool? IsPaused { get; set; }

        public byte[] CronExpressionTimeStamp { get; set; }

        public DateTime? ConductEndDate { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? ConductStartDate { get; set; }
        public int? SpanInYears { get; set; }
        public int? SpanInMonths { get; set; }
        public int? SpanInDays { get; set; }
        public bool IsIncludeAllQuestions { get; set; }
        public List<SelectedQuestionModel> SelectedQuestions { get; set; }
        public List<Guid?> SelectedCategories { get; set; }
        public Guid? ResponsibleUserId { get; set; }
        public string TimeZone { get; set; }
    }

    public class FileDetailsModel
    {
        public string FileName { get; set; }
        public string FileUrl { get; set; }
        public string Filetype { get; set; }
    }
    public class FileBytesModel
    {
        public string VisualizationName { get; set; }
        public string FileType { get; set; }
        public string FileByteStrings { get; set; }
    }
}
