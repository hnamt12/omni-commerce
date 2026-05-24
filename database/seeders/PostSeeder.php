<?php

namespace Database\Seeders;

use App\Models\Post;
use Illuminate\Database\Seeder;

class PostSeeder extends Seeder
{
    public function run(): void
    {
        $posts = [
            [
                'title'            => 'Đánh giá iPhone 17 Pro Max: Đỉnh cao công nghệ hay chỉ là nâng cấp nhỏ?',
                'slug'             => 'danh-gia-iphone-17-pro-max-dinh-cao-cong-nghe',
                'thumbnail'        => 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=800&q=80',
                'summary'          => 'iPhone 17 Pro Max chính thức ra mắt với chip A19 Bionic và camera periscope 5x — nhưng liệu đây có phải là bước đột phá thực sự hay Apple chỉ đang "an toàn"? Chúng tôi đã dùng thử trong 2 tuần để tìm câu trả lời.',
                'content'          => '<h2>Thiết kế & Màn hình</h2>
<p>Apple đã dũng cảm thay đổi thiết kế của dòng Pro năm nay. Khung titanium grade 5 mỏng hơn 8% so với thế hệ trước, trong khi màn hình ProMotion 6.9 inch đạt độ sáng tối đa 3000 nits — con số đủ để bạn đọc màn hình ngay cả giữa trưa hè Sài Gòn.</p>
<p>Dynamic Island tiếp tục được cải tiến, giờ đây hỗ trợ đa nhiệm tốt hơn với giao diện context-aware: khi bạn đang chạy bộ, nó tự động hiển thị số liệu sức khỏe; khi điều hướng, nó thu nhỏ lại bản đồ thu nhỏ dạng PiP.</p>

<h2>Hiệu năng — Chip A19 Bionic</h2>
<p>Chip A19 Bionic được TSMC sản xuất trên tiến trình 2nm, mang lại hiệu suất CPU tăng 22% và GPU tăng 18% so với A18. Trong các benchmark thực tế, iPhone 17 Pro Max xử lý video ProRes 8K 120fps mà không cần quạt tản nhiệt — điều mà nhiều laptop gaming vẫn chưa làm được.</p>
<p>RAM 12GB LPDDR5X đảm bảo multitasking mượt mà, đặc biệt với các tác vụ AI on-device như dịch thuật thời gian thực và tóm tắt email bằng Apple Intelligence.</p>

<h2>Camera — Điểm mạnh nhất</h2>
<p>Hệ thống triple-lens mới gồm: Main 200MP f/1.6, Ultra-wide 48MP f/2.0 và Periscope Tele 12MP 5x. Khả năng chụp đêm được cải thiện đáng kể nhờ sensor lớn hơn và thuật toán Photonic Engine thế hệ 3.</p>
<p>Video vẫn là thế mạnh vượt trội. Chế độ Cinematic Mode giờ hỗ trợ 4K 120fps với Log profile — đủ để các content creator chuyên nghiệp cân nhắc thay thế máy quay Sony a7S III cho các dự án ngắn.</p>

<h2>Pin & Sạc</h2>
<p>Pin 4685mAh với công nghệ sạc nhanh 35W (có dây) và 25W MagSafe. Trong điều kiện sử dụng thực tế hỗn hợp (stream, chụp ảnh, gọi video), máy cầm được khoảng 1.5 ngày — cải thiện khoảng 20% so với iPhone 16 Pro Max.</p>

<h2>Kết luận</h2>
<p>iPhone 17 Pro Max là chiếc smartphone tốt nhất Apple từng làm, nhưng "tốt nhất" không có nghĩa là "cần phải mua ngay". Nếu bạn đang dùng iPhone 15 Pro hoặc cũ hơn, đây là lý do chính đáng để nâng cấp. Nếu bạn vừa mua iPhone 16 Pro Max năm ngoái, hãy chờ thêm một chu kỳ nữa.</p>
<p><strong>Điểm đánh giá: 9.2/10</strong></p>',
                'is_active'        => true,
                'views'            => 1247,
                'meta_title'       => 'Đánh giá iPhone 17 Pro Max 2026 — Có đáng mua không? | OmniCommerce',
                'meta_description' => 'Review chi tiết iPhone 17 Pro Max: chip A19 Bionic, camera 200MP periscope 5x, pin 1.5 ngày. Phân tích khách quan để giúp bạn quyết định có nên mua không.',
            ],
            [
                'title'            => 'Top 5 Mẹo Tiết Kiệm Pin Samsung Galaxy S25 Ultra Mà Ít Ai Biết',
                'slug'             => 'top-5-meo-tiet-kiem-pin-samsung-galaxy-s25-ultra',
                'thumbnail'        => 'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=800&q=80',
                'summary'          => 'Galaxy S25 Ultra có viên pin 5000mAh nhưng nhiều người dùng vẫn phàn nàn về thời lượng. 5 mẹo thực chiến dưới đây sẽ giúp bạn kéo dài thêm 30–50% thời gian sử dụng mà không cần hy sinh trải nghiệm.',
                'content'          => '<h2>1. Tắt Always-On Display khi không cần thiết</h2>
<p>Always-On Display (AOD) của Galaxy S25 Ultra trông rất đẹp nhưng tiêu thụ khoảng 8–12% pin mỗi ngày. Thay vì tắt hoàn toàn, hãy vào <strong>Settings → Lock Screen → Always On Display</strong> và chọn chế độ <em>"Show as scheduled"</em> — chỉ bật trong giờ làm việc từ 8h–22h.</p>

<h2>2. Giới hạn Refresh Rate về 60Hz khi đọc sách hoặc duyệt web</h2>
<p>Màn hình 120Hz LTPO của S25 Ultra tự động điều chỉnh từ 1Hz đến 120Hz, nhưng đây là lý thuyết. Trong thực tế, khi cuộn feed mạng xã hội, màn hình luôn chạy ở 120Hz. Vào <strong>Settings → Display → Motion Smoothness</strong> và chọn <em>"Standard (60Hz)"</em> trong những lúc bạn chỉ đọc văn bản — bạn sẽ tiết kiệm được ~15% pin.</p>

<h2>3. Quản lý ứng dụng nền bằng chế độ Deep Sleep</h2>
<p>Samsung có tính năng ít người biết gọi là <em>Deep Sleeping Apps</em>. Vào <strong>Settings → Battery → Background usage limits → Deep sleeping apps</strong> và thêm những ứng dụng ít dùng vào danh sách. Chúng sẽ không được phép chạy nền, nhận thông báo hoặc refresh — tiết kiệm đáng kể pin và RAM.</p>

<h2>4. Tắt các tính năng kết nối không dùng</h2>
<p>Ultra-Wideband (UWB), NFC, Bluetooth Scanning và Wi-Fi Scanning là những "kẻ hút pin thầm lặng". Nếu bạn không dùng Samsung SmartThings hay tìm kiếm thiết bị lân cận, hãy tắt chúng trong Quick Settings. Chỉ bước này thôi có thể tiết kiệm thêm 1–2 giờ sử dụng.</p>

<h2>5. Tối ưu hóa màu sắc màn hình</h2>
<p>Màn hình AMOLED chỉ tốn điện cho các pixel sáng — pixel đen thực sự tắt hoàn toàn. Hãy dùng <strong>Dark Mode</strong> (tiết kiệm ~20% pin màn hình) và đặt hình nền động thành hình nền tối hoàn toàn. Màu nền <code>#000000</code> là tốt nhất cho màn hình AMOLED.</p>

<h2>Kết quả thực tế</h2>
<p>Áp dụng cả 5 mẹo trên, chúng tôi đo được thời lượng sử dụng tăng từ 6.5 giờ lên 9.2 giờ screen-on time — tương đương tăng 41% thời gian sử dụng thực tế trên cùng một chiếc Galaxy S25 Ultra.</p>',
                'is_active'        => true,
                'views'            => 892,
                'meta_title'       => 'Top 5 Mẹo Tiết Kiệm Pin Samsung Galaxy S25 Ultra Hiệu Quả Nhất 2026',
                'meta_description' => 'Khám phá 5 mẹo tiết kiệm pin Galaxy S25 Ultra mà Samsung không nói với bạn. Tăng thêm 30–50% thời lượng pin chỉ trong vài phút thiết lập.',
            ],
            [
                'title'            => 'Xu Hướng Smartphone 2026: AI On-Device, Màn Hình Gập và Sạc Không Dây 100W',
                'slug'             => 'xu-huong-smartphone-2026-ai-ondevice-man-hinh-gap',
                'thumbnail'        => 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&q=80',
                'summary'          => 'Năm 2026 đánh dấu bước chuyển đổi lớn nhất của ngành smartphone kể từ khi iPhone đầu tiên ra mắt năm 2007. AI on-device, màn hình gập thế hệ 3 và sạc không dây siêu nhanh đang định hình lại cách chúng ta dùng điện thoại.',
                'content'          => '<h2>1. AI On-Device — Trí Tuệ Nhân Tạo Không Cần Internet</h2>
<p>Xu hướng lớn nhất của 2026 không phải là camera nhiều MP hơn hay màn hình to hơn — mà là AI chạy hoàn toàn trên thiết bị, không cần kết nối cloud. Qualcomm Snapdragon 8 Elite Gen 2 và Apple A19 Bionic đều được tích hợp NPU (Neural Processing Unit) đủ mạnh để chạy các mô hình ngôn ngữ 7B tham số.</p>
<p>Điều này có nghĩa là: phiên dịch thời gian thực trong cuộc gọi, tóm tắt tài liệu PDF dài 100 trang, và chỉnh sửa ảnh bằng lệnh thoại — tất cả thực hiện ngay trên máy, bảo mật hoàn toàn và không tốn data.</p>

<h2>2. Màn Hình Gập Thế Hệ 3 — Nếp Gập Gần Như Vô Hình</h2>
<p>Samsung Galaxy Z Fold 7 và OPPO Find N4 đều sử dụng công nghệ UTG (Ultra-Thin Glass) thế hệ mới với độ dày chỉ 30 micron — mỏng hơn tóc người. Nếp gập giờ đây hầu như không còn thấy được bằng mắt thường, giải quyết điểm yếu lớn nhất của dòng máy gập từ trước đến nay.</p>
<p>Giá thành cũng đang giảm nhanh: dự kiến đến Q4/2026, smartphone màn hình gập cao cấp sẽ có giá dưới 25 triệu đồng tại Việt Nam.</p>

<h2>3. Sạc Không Dây 100W — Nhanh Như Cắm Dây</h2>
<p>Xiaomi đã tiên phong với công nghệ sạc không dây 80W vào năm 2024. Năm 2026, OPPO và Samsung đang chạy đua để đạt mốc 100W wireless charging. Công nghệ mới dùng cuộn dây thiết kế đặc biệt và chip quản lý điện thông minh để giảm nhiệt sinh ra trong quá trình sạc không dây.</p>

<h2>4. Camera Dưới Màn Hình — Selfie Không Lỗ</h2>
<p>Under-display camera (UDC) đã tồn tại vài năm nhưng chất lượng ảnh luôn là vấn đề. Năm 2026, các nhà sản xuất sử dụng pixel sub-resolution mới và thuật toán AI reconstruction để cải thiện chất lượng ảnh UDC lên gần bằng camera thông thường. Xiaomi Mix Fold 4 và Samsung Galaxy Z Fold 7 đều đã trang bị tính năng này.</p>

<h2>5. Vật Liệu Nano-Ceramic — Chống Trầy Gần Tuyệt Đối</h2>
<p>Corning Gorilla Glass Armor và kính ceramic mới của Samsung có khả năng chống trầy xước gần tuyệt đối (độ cứng Mohs 8.5 trên thang 10). Kết hợp với khung titan cường lực, smartphone 2026 đang trở nên bền hơn bao giờ hết mà không tăng trọng lượng.</p>

<h2>Nhận định</h2>
<p>Năm 2026 là năm của sự trưởng thành. Thay vì chạy theo spec, các nhà sản xuất đang tập trung vào trải nghiệm thực tế: AI hữu ích, thiết kế bền đẹp và sạc nhanh tiện lợi. Người dùng Việt Nam sẽ được hưởng lợi nhiều nhất từ xu hướng này.</p>',
                'is_active'        => true,
                'views'            => 1489,
                'meta_title'       => 'Xu Hướng Smartphone 2026: AI, Màn Hình Gập, Sạc 100W | OmniCommerce',
                'meta_description' => 'Phân tích 5 xu hướng smartphone lớn nhất năm 2026: AI on-device, nếp gập vô hình, sạc không dây 100W, camera dưới màn hình và vật liệu nano-ceramic.',
            ],
            [
                'title'            => 'So Sánh Chi Tiết: Xiaomi 15 Ultra vs Samsung Galaxy S25 Ultra — Ai Thắng Cuộc?',
                'slug'             => 'so-sanh-xiaomi-15-ultra-vs-samsung-galaxy-s25-ultra',
                'thumbnail'        => 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?w=800&q=80',
                'summary'          => 'Hai flagship Android đỉnh nhất đầu 2026 đối đầu trực tiếp: Xiaomi 15 Ultra với camera Leica và pin 6000mAh, đối đầu Samsung Galaxy S25 Ultra với bút S Pen và hệ sinh thái One UI. Đây là bài so sánh toàn diện nhất bạn sẽ đọc.',
                'content'          => '<h2>Thiết Kế & Cầm Nắm</h2>
<p><strong>Xiaomi 15 Ultra</strong> có thiết kế ceramic đặc trưng, cụm camera tròn nổi bật với logo Leica. Máy nặng 226g — khá nặng nhưng phân phối trọng lượng tốt. Mặt lưng ceramic cho cảm giác cao cấp và chống trầy xuất sắc.</p>
<p><strong>Samsung Galaxy S25 Ultra</strong> giữ thiết kế titan quen thuộc nhưng mỏng hơn 2025. Góc bo tròn hơn so với các thế hệ trước, bỏ cạnh thẳng góc — một thay đổi gây tranh cãi nhưng cầm thoải mái hơn. S Pen tích hợp vẫn là điểm khác biệt không ai bắt chước được.</p>

<h2>Màn Hình</h2>
<table style="width:100%; border-collapse:collapse; margin: 12px 0;">
  <thead><tr style="background:#f3f4f6;"><th style="padding:8px; text-align:left; border:1px solid #e5e7eb;">Tiêu chí</th><th style="padding:8px; text-align:center; border:1px solid #e5e7eb;">Xiaomi 15 Ultra</th><th style="padding:8px; text-align:center; border:1px solid #e5e7eb;">Samsung S25 Ultra</th></tr></thead>
  <tbody>
    <tr><td style="padding:8px; border:1px solid #e5e7eb;">Kích thước</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">6.73 inch</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">6.9 inch</td></tr>
    <tr><td style="padding:8px; border:1px solid #e5e7eb;">Độ phân giải</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">3200×1440 (QHD+)</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">3088×1440 (QHD+)</td></tr>
    <tr><td style="padding:8px; border:1px solid #e5e7eb;">Độ sáng tối đa</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">3200 nits</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">2600 nits</td></tr>
    <tr><td style="padding:8px; border:1px solid #e5e7eb;">Refresh rate</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">1–120Hz LTPO</td><td style="padding:8px; text-align:center; border:1px solid #e5e7eb;">1–120Hz LTPO</td></tr>
  </tbody>
</table>

<h2>Hiệu Năng</h2>
<p>Cả hai đều dùng Snapdragon 8 Elite Gen 2 (Xiaomi phiên bản "for Xiaomi" được ép xung cao hơn). Trong các bài test thực tế, hiệu năng gần như tương đương. Xiaomi 15 Ultra tản nhiệt tốt hơn nhờ buồng hơi lớn hơn, duy trì hiệu năng cao lâu hơn trong các tác vụ nặng như render video.</p>

<h2>Camera — Điểm Nóng Nhất</h2>
<p><strong>Xiaomi 15 Ultra</strong> hợp tác với Leica: Main 200MP 1-inch sensor, Ultra-wide 50MP, Periscope 5x 50MP và Periscope 10x 50MP. Đây là hệ thống camera đa năng nhất hiện nay với 4 camera thực sự chất lượng cao.</p>
<p><strong>Samsung S25 Ultra</strong> có Main 200MP, Ultra-wide 12MP, Periscope 5x 50MP và Tele 3x 10MP. Chất lượng ảnh Samsung nhất quán và đáng tin cậy hơn qua xử lý AI, nhưng Xiaomi dẫn ở ảnh chân dung nhờ sensor Leica.</p>

<h2>Pin & Sạc</h2>
<p>Đây là chiến thắng rõ ràng của Xiaomi: pin 6000mAh vs 5000mAh, sạc nhanh 90W có dây vs 45W, và quan trọng là sạc không dây 80W vs 15W. Xiaomi 15 Ultra sạc đầy từ 0% trong 37 phút — Samsung cần đến 68 phút.</p>

<h2>Kết Luận</h2>
<p>Chọn <strong>Xiaomi 15 Ultra</strong> nếu: bạn ưu tiên camera, pin mạnh và sạc nhanh, và không ngại học MIUI.</p>
<p>Chọn <strong>Samsung Galaxy S25 Ultra</strong> nếu: bạn cần S Pen, muốn hệ sinh thái Samsung DeX, và ưu tiên sự ổn định phần mềm lâu dài.</p>
<p>Không có kẻ thua trong cuộc đua này — cả hai đều là những flagship Android xuất sắc nhất hiện tại.</p>',
                'is_active'        => true,
                'views'            => 763,
                'meta_title'       => 'So Sánh Xiaomi 15 Ultra vs Samsung Galaxy S25 Ultra: Flagship nào đáng mua hơn?',
                'meta_description' => 'So sánh chi tiết Xiaomi 15 Ultra và Samsung Galaxy S25 Ultra về thiết kế, màn hình, camera, hiệu năng, pin và giá. Bài phân tích đầy đủ nhất 2026.',
            ],
            [
                'title'            => 'Hướng Dẫn Toàn Diện: Chọn Mua Tai Nghe Bluetooth Đúng Loại Cho Nhu Cầu Của Bạn',
                'slug'             => 'huong-dan-chon-mua-tai-nghe-bluetooth-dung-loai',
                'thumbnail'        => 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
                'summary'          => 'Thị trường tai nghe Bluetooth 2026 có hàng trăm lựa chọn từ 200 nghìn đến 10 triệu đồng. Bài viết này phân tích các tiêu chí quan trọng nhất để bạn không mất tiền oan vào những tính năng không cần thiết.',
                'content'          => '<h2>Bước 1: Xác Định Mục Đích Sử Dụng</h2>
<p>Trước khi xem bất kỳ thông số kỹ thuật nào, hãy tự hỏi: bạn dùng tai nghe chủ yếu để làm gì?</p>
<ul>
  <li><strong>Nghe nhạc tại nhà/văn phòng:</strong> Ưu tiên chất âm và ANC. Chọn dạng over-ear (chụp tai).</li>
  <li><strong>Chạy bộ/tập gym:</strong> Ưu tiên chống nước IPX5+ và thiết kế bám tai. Chọn dạng in-ear thể thao.</li>
  <li><strong>Gọi điện công việc:</strong> Ưu tiên micro chất lượng cao và ANC microphone. Chọn over-ear hoặc in-ear có mic tốt.</li>
  <li><strong>Gaming:</strong> Ưu tiên độ trễ thấp (dưới 40ms) và âm thanh vòm. Chọn tai nghe gaming chuyên dụng.</li>
</ul>

<h2>Bước 2: Hiểu Về Chống Ồn Chủ Động (ANC)</h2>
<p>ANC (Active Noise Cancellation) sử dụng micro để phân tích âm thanh môi trường, sau đó tạo ra sóng âm ngược pha để triệt tiêu tiếng ồn. Đây là công nghệ hiệu quả nhưng có nhiều mức độ khác nhau:</p>
<p><strong>ANC tốt nhất hiện nay:</strong> Sony WH-1000XM6, Apple AirPods Max Gen 2, Bose QuietComfort 45. Chúng có thể giảm đến 35dB tiếng ồn môi trường — đủ để làm việc yên tĩnh trên máy bay.</p>
<p><strong>Lưu ý:</strong> ANC tốn thêm 15–25% pin và đôi khi gây cảm giác áp tai khó chịu với một số người. Hãy thử trước khi mua nếu có thể.</p>

<h2>Bước 3: Codec Bluetooth — Quan Trọng Hơn Bạn Nghĩ</h2>
<p>Codec quyết định chất lượng âm thanh truyền qua Bluetooth:</p>
<ul>
  <li><strong>SBC:</strong> Codec cơ bản, hỗ trợ trên mọi thiết bị. Chất lượng ổn cho nghe nhạc thông thường.</li>
  <li><strong>AAC:</strong> Apple sử dụng, chất lượng tốt hơn SBC đáng kể, đặc biệt trên iPhone.</li>
  <li><strong>aptX Adaptive:</strong> Qualcomm, chất lượng gần lossless, độ trễ thấp. Cần cả tai nghe và điện thoại hỗ trợ.</li>
  <li><strong>LDAC:</strong> Sony, truyền tải 990kbps — gần bằng lossless. Tốt nhất cho audiophile nhưng tốn pin hơn.</li>
  <li><strong>LC3 (Bluetooth LE Audio):</strong> Chuẩn mới 2026, hiệu quả hơn LDAC ở cùng bitrate, hỗ trợ đa thiết bị đồng thời.</li>
</ul>

<h2>Bước 4: Kiểm Tra Thời Lượng Pin Thực Tế</h2>
<p>Các con số pin nhà sản xuất công bố thường đo ở mức âm lượng 50% và tắt ANC. Trong thực tế sử dụng bình thường (70% âm lượng, bật ANC), hãy nhân số giờ pin với 0.6–0.7 để có ước tính thực tế.</p>
<p>Ví dụ: Sony WH-1000XM6 công bố 40 giờ → thực tế khoảng 26–28 giờ với ANC bật và âm lượng 70%.</p>

<h2>Gợi Ý Theo Tầm Giá</h2>
<p><strong>Dưới 1 triệu:</strong> QCY H3, Edifier W820NB — chất âm ổn, ANC cơ bản.</p>
<p><strong>1–3 triệu:</strong> Anker Soundcore Q45, JBL Live 770NC — cân bằng tốt giữa chất âm và tính năng.</p>
<p><strong>3–6 triệu:</strong> Sony WH-CH720N, Jabra Evolve2 55 — ANC tốt, mic chuyên nghiệp.</p>
<p><strong>Trên 6 triệu:</strong> Sony WH-1000XM6, AirPods Max — đỉnh cao chống ồn và chất âm.</p>

<h2>Kết Luận</h2>
<p>Không có tai nghe "tốt nhất" — chỉ có tai nghe phù hợp nhất với nhu cầu và ngân sách của bạn. Ưu tiên thử tai nghe trực tiếp tại cửa hàng trước khi quyết định, đặc biệt với các sản phẩm trên 3 triệu đồng.</p>',
                'is_active'        => true,
                'views'            => 534,
                'meta_title'       => 'Hướng Dẫn Chọn Mua Tai Nghe Bluetooth 2026: ANC, Codec, Pin và Giá | OmniCommerce',
                'meta_description' => 'Cách chọn tai nghe Bluetooth đúng nhu cầu: phân tích ANC, codec LDAC/aptX/AAC, thời lượng pin thực tế và gợi ý sản phẩm theo tầm giá từ 200K đến 10 triệu đồng.',
            ],
        ];

        foreach ($posts as $index => $post) {
            Post::updateOrCreate(
                ['slug' => $post['slug']],
                array_merge($post, [
                    'status'       => 'published',
                    'published_at' => now()->subDays(rand(1, 30))->subHours(rand(0, 23)),
                    'created_at'   => now(),
                    'updated_at'   => now(),
                ])
            );
        }

        $this->command->info('✅ PostSeeder: 5 bài viết demo đã được thêm thành công!');
    }
}
