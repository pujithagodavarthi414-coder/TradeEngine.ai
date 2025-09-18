using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WidgetSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public WidgetSearchCriteriaInputModel() : base(InputTypeGuidConstants.WidgetSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? WidgetId { get; set; }

        public string WidgetName { get; set; }

        public string Tags { get; set; }

        public bool? IsExoport { get; set; }

        public Guid? TagId { get; set; }

        public bool? IsFavouriteWidget { get; set; }

        public bool? IsQuery { get; set; }

        public bool? IsFromSearch { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WidgetId = " + WidgetId);
            stringBuilder.Append("WidgetName = " + WidgetName);
            return stringBuilder.ToString();
        }
    }
}
