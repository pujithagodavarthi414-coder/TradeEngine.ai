using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class CustomeHtmlAppDetailsSearchOutputModel
    {
        public string CustomHtmlAppName { get; set; }
        public string Description { get; set; }
        public string HtmlCode { get; set; }
        public List<Guid?> RoleId { get; set; }
    }

    public class CustomeHtmlAppDetailsOutputModel
    {
        public string CustomHtmlAppName { get; set; }
        public string Description { get; set; }
        public string HtmlCode { get; set; }
        public Guid? RoleId { get; set; }
    }
}
