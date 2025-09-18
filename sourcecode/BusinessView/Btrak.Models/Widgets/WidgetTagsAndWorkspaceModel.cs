using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WidgetTagsAndWorkspaceModel
    {
        public Guid? WidgetId { get; set; }

        public bool IsCustomWidget { get; set; }

        public bool IsHtml { get; set; }

        public bool IsProcess { get; set; }

    }

    public class WidgetTagsAndWorkspaceReturnModel
    {
        public Guid? WidgetId { get; set; }

        public string WidgetTags { get; set; }

        public string WidgetWorkSpaces { get; set; }

        public bool? IsFavouriteWidget { get; set; }
    }

    public class FavouriteWidgetsInputModel
    {
        public Guid? WidgetId { get; set; }

        public bool? IsFavouriteWidget { get; set; }
    }
}
