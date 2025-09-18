using System;
using System.Threading.Tasks;
using Btrak.Models;
using Btrak.Models.TestRail;
using Btrak.Services.FileUploadDownload;
using BTrak.Common;
using PuppeteerSharp;

namespace Btrak.Services.Chromium
{
    public class ChromiumService : IChromiumService
    {
        private readonly IFileStoreService _fileStoreService;

        public ChromiumService(IFileStoreService fileStoreService)
        {
            _fileStoreService = fileStoreService;
        }

        public async Task<string> CaptureImage(string htmlFileContent, string fileName)
        {
            try
            {
                string fileFullPath = System.IO.Path.GetTempPath() + Guid.NewGuid() + ".png";

                LoggingManager.Info(fileFullPath);

                var browserFetcher = new BrowserFetcher(new BrowserFetcherOptions
                {
                    Path = System.IO.Path.GetTempPath()
                });

                await browserFetcher.DownloadAsync(BrowserFetcher.DefaultRevision);

                using (var browser = await Puppeteer.LaunchAsync(new LaunchOptions
                {
                    Headless = true,
                    ExecutablePath = browserFetcher.RevisionInfo(BrowserFetcher.DefaultRevision).ExecutablePath
                }))
                {
                    LoggingManager.Info("browser=" + browser.ToString());

                    using (var page = await browser.NewPageAsync())
                    {
                        LoggingManager.Info(page.ToString());

                        LoggingManager.Info(htmlFileContent);

                        await page.SetContentAsync(htmlFileContent, new NavigationOptions
                        {
                            WaitUntil = new[] { WaitUntilNavigation.DOMContentLoaded }
                        });

                        await page.ScreenshotAsync(fileFullPath, new ScreenshotOptions
                        {
                            FullPage = true
                        });

                        LoggingManager.Info("Generating blobUrl");

                        var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                        {
                            MemoryStream = System.IO.File.ReadAllBytes(fileFullPath),
                            FileName = fileName + DateTime.Now.Date
                        });

                        LoggingManager.Info("blobUrl=" + blobUrl);

                        await browser.CloseAsync();

                        return blobUrl;
                    }
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CaptureImage", " ChromiumService", ex.Message), ex);

                return null;
            }
        }

        public async Task<PdfGenerationOutputModel> GeneratePdf(string htmlFileContent, string fileName, string assetFileName)
        {
            try
            {
                LoggingManager.Info("Entering into GeneratePdf in Chromium Service");
                string fileFullPath = System.IO.Path.GetTempPath() + Guid.NewGuid() + ".pdf";
                LoggingManager.Info("File full path" + fileFullPath);
                LoggingManager.Info("Generating Pdf file in Chromium Service in the temporary path " + System.IO.Path.GetTempPath());
                var browserFetcher = new BrowserFetcher(new BrowserFetcherOptions
                {
                    Path = System.IO.Path.GetTempPath()
                });
                await browserFetcher.DownloadAsync(BrowserFetcher.DefaultRevision);
                LoggingManager.Info("Generating Pdf file in Chromium Service in the temporary path " + System.IO.Path.GetTempPath());
                using (var browser = await Puppeteer.LaunchAsync(new LaunchOptions
                {
                    Headless = true,
                    ExecutablePath = browserFetcher.RevisionInfo(BrowserFetcher.DefaultRevision).ExecutablePath
                }))
                {
                    LoggingManager.Info("browser " + browser);
                    using (var page = await browser.NewPageAsync())
                    {
                        await page.SetContentAsync(htmlFileContent);
                        await page.PdfAsync(fileFullPath);
                        LoggingManager.Info("Pdf file generated in Chromium Service");
                        var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                        {
                            MemoryStream = System.IO.File.ReadAllBytes(fileFullPath),
                            FileName = !string.IsNullOrEmpty(assetFileName) ? assetFileName + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + "-Assets.pdf" : fileName + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year + "-Reports.pdf"
                        });
                        var pdfOutputModel = new PdfGenerationOutputModel()
                        {
                            ByteStream = System.IO.File.ReadAllBytes(fileFullPath),
                            BlobUrl = blobUrl
                        };
                        LoggingManager.Info("Returning PdfByteStream in Chromium Service");
                        return pdfOutputModel;
                    }
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CaptureImage", " ChromiumServicePdfGeneration", ex.Message), ex);

                return null;
            }

        }

        public async Task<PdfGenerationOutputModel> GenerateExecutionPdf(string htmlFileContent, string fileName, string assetFileName)
        {
            try
            {
                LoggingManager.Info("Entering into GeneratePdf in Chromium Service");
                string fileFullPath = "F:\\data\\" + Guid.NewGuid() + ".pdf";
                LoggingManager.Info("File full path" + fileFullPath);
                LoggingManager.Info("Generating Pdf file in Chromium Service in the temporary path " + System.IO.Path.GetTempPath());
                var browserFetcher = new BrowserFetcher(new BrowserFetcherOptions
                {
                    Path = "F:\\data\\"
                });
                //await browserFetcher.DownloadAsync(BrowserFetcher.DefaultRevision);
                LoggingManager.Info("Generating Pdf file in Chromium Service in the temporary path " + System.IO.Path.GetTempPath());
                using (var browser = await Puppeteer.LaunchAsync(new LaunchOptions
                {
                    Headless = true,
                    ExecutablePath = browserFetcher.RevisionInfo(BrowserFetcher.DefaultRevision).ExecutablePath
                }).ConfigureAwait(false))
                {
                    LoggingManager.Info("browser " + browser);
                    using (var page = await browser.NewPageAsync())
                    {
                        await page.SetContentAsync(htmlFileContent);
                        await page.PdfAsync(fileFullPath);
                        LoggingManager.Error("Pdf file generated in Chromium Service");
                        var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                        {
                            MemoryStream = System.IO.File.ReadAllBytes(fileFullPath),
                            FileName = !string.IsNullOrEmpty(assetFileName) ? assetFileName + DateTime.Now.Day + DateTime.Now.Month + DateTime.Now.Year + "-Assets.pdf" : fileName + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year + "-Reports.pdf"
                        });
                        var pdfOutputModel = new PdfGenerationOutputModel()
                        {
                            ByteStream = System.IO.File.ReadAllBytes(fileFullPath),
                            BlobUrl = blobUrl
                        };
                        LoggingManager.Info("Returning PdfByteStream in Chromium Service");
                        return pdfOutputModel;
                    }
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CaptureImage", " ChromiumServicePdfGeneration", ex.Message), ex);

                return null;
            }

        }
    }
}