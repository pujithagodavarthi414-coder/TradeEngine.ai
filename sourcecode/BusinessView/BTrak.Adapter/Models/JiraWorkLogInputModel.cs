using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BTrak.Adapter.Models
{
    public class JiraWorkLogInputModel
    {
        public Int64 timeSpentSeconds { get; set; }
    }

    public class Comment
    {
        public string type { get; set; }
        public int version { get; set; }
        public List<Content> content { get; set; }
    }

    public class Content
    {
        public string type { get; set; }
        public List<Content2> content { get; set; }
    }

    public class Content2
    {
        public string text { get; set; }
        public string type { get; set; }
    }
}
