using System;
using System.Collections.Generic;

namespace Btrak.Models.MyWork
{
    public class GetGoalBurnDownChartOutputModel
    {
        public DateTime Date { get; set; }
        public float ExpectedBurnDown { get; set; }
        public float ActualBurnDown { get; set; }
    }

    public class Values
    {
        public DateTime DateTime { get; set; }
        public string Time { get; set; }
        public float Value { get; set; }
    }

    public class GeneralOutput
    {
        public List<Values> ExpectedBurnDown { get; set; }
        public List<Values> ActualBurnDown { get; set; }
    }
}
