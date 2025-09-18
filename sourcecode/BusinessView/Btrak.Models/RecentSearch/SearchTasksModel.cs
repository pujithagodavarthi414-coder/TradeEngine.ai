using System;
using static BTrak.Common.Enumerators;

namespace Btrak.Models.RecentSearch
{
    public class SearchTasksModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public string UniqueName { get; set; }
        public TaskType Type { get; set; }
        public string SearchText { get; set;}
    }
}
