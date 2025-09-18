using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class SearchModel 
    {
        public string SearchText { get; set; }
        public bool IsAllUsers { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsForTracker { get; set; }
    }
}
