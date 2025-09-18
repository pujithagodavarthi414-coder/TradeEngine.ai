using System;
using System.Text;

namespace Btrak.Models.Features
{
    public class AppMenuItemApiReturnModel
    {
        public Guid Id { get; set; }
        public Guid OriginalId { get; set; }
        public string MenuCategory { get; set; }
        public string ProcessedOrderNumber { get; set; }
        public string ParentMenu { get; set; }
        public string Menu { get; set; }
        public string Type { get; set; }
        public string ToolTip { get; set; }
        public string State { get; set; }
        public string Icon { get; set; }
        public Guid ParentMenuItemId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", OriginalId = " + OriginalId);
            stringBuilder.Append(", MenuCategory = " + MenuCategory);
            stringBuilder.Append(", ProcessedOrderNumber = " + ProcessedOrderNumber);
            stringBuilder.Append(", ParentMenu = " + ParentMenu);
            stringBuilder.Append(", Menu = " + Menu);
            stringBuilder.Append(", Type = " + Type);
            stringBuilder.Append(", ToolTip = " + ToolTip);
            stringBuilder.Append(", State = " + State);
            stringBuilder.Append(", Icon = " + Icon);
            stringBuilder.Append(", ParentMenuItemId = " + ParentMenuItemId);
            return stringBuilder.ToString();
        }
    }
}
