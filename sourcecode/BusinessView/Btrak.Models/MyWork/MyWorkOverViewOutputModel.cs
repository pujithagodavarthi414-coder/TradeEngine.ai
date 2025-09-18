using System.Text;

namespace Btrak.Models.MyWork
{
    public class MyWorkOverViewOutputModel
    {
        public int? ProjectManagementWorkCount { get; set; }
        public int? AdhocWorkCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ProjectManagementWorkCount = " + ProjectManagementWorkCount);
            stringBuilder.Append(", AdhocWorkCount  = " + AdhocWorkCount);
            return stringBuilder.ToString();
        }
    }
}
