using Btrak.Models.Features;
using Btrak.Models.RecentSearch;
using Btrak.Models.Widgets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class SearchMenuDataModel
    {
        public List<AppMenuItemApiReturnModel> MenuItems { get; set; }
        public List<WidgetApiReturnModel> Widgets { get; set; }
        public List<WorkspaceApiReturnModel> Workspaces { get; set; }
        public List<RecentSearchModel> RecentSearch { get; set; }
    }
}
