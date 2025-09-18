using System;

namespace Btrak.Models.Burndown
{
    public class BurnDownDataModel
    {
        public DateTime Date { get; set; }
        public int Standard { get; set; }
        public int Done { get; set; }
    }
}