using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class CronExpressionApiReturnModel
    {
        public Guid? CronExpressionId { get; set; }

        public string CronExpressionName { get; set; }

        public string CronExpressionDescription { get; set; }

        public string CronExpression { get; set; }

        public Guid? CustomWidgetId { get; set; }

        public string SelectedChartIds { get; set; }

        public string TemplateType { get; set; }

        public string TemplateUrl { get; set; }

        public string ChartsUrls { get; set; }

        public int? JobId { get; set; }

        public Guid? CompanyId { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomWidgetId = " + CustomWidgetId);

            stringBuilder.Append("CronExpressionId = " + CronExpressionId);

            stringBuilder.Append("CronExpression = " + CronExpression);

            stringBuilder.Append("SelectedChartIds = " + SelectedChartIds);

            stringBuilder.Append("TemplateType = " + TemplateType);

            stringBuilder.Append("ChartsUrls = " + ChartsUrls);

            stringBuilder.Append("TemplateUrl = " + TemplateUrl);

            stringBuilder.Append("JobId = " + JobId);

            stringBuilder.Append("CompanyId = " + CompanyId);

            stringBuilder.Append("CronExpressionName = " + CronExpressionName);

            return stringBuilder.ToString();
        }
    }
}
