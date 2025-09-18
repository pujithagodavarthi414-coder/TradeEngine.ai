namespace Btrak.Models.Burndown
{
    public class BurnDownConfigModel
    {
        public string ContainerId { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public MarginsModel Margins { get; set; }
        public BurnDownChartDisplayColorsModel DisplayColors { get; set; }
        public string StartLabel { get; set; }
        public string XTitle { get; set; }
    }
}