using System;
using System.Collections.Generic;

namespace Btrak.Models.Dashboard
{
    public class WidgetInputModel
    {
        public Guid? WidgetId { get; set; }
        public string WidgetHtmlCode { get; set; }
        public List<Guid?> UserIds { get; set; }
        public Guid? ClientId { get; set; }
    }
    public class ModuleTabModel
    {
        public Guid? ModuleId { get; set; }
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public bool IsUpsert { get; set; }
    }
}
