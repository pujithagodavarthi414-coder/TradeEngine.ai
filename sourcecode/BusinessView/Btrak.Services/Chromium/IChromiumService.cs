using Btrak.Models.TestRail;
using System.Threading.Tasks;

namespace Btrak.Services.Chromium
{
    public interface IChromiumService
    {
        Task<string> CaptureImage(string htmlFileContent, string fileName);

        Task<PdfGenerationOutputModel> GeneratePdf(string htmlFileContent, string fileName, string assetFileName);
        Task<PdfGenerationOutputModel> GenerateExecutionPdf(string htmlFileContent, string fileName, string assetFileName);
    }
}