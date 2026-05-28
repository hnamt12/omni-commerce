<?php

namespace Database\Seeders;

use App\Models\Post;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class PostPaginationSeeder extends Seeder
{
    public function run(): void
    {
        $posts = [
            [
                'title' => 'Apple Vision Pro 2: Kính AR Thế Hệ Mới Có Thực Sự Thay Thế Màn Hình Máy Tính?',
                'slug' => Str::slug('Apple Vision Pro 2 Kinh AR The He Moi Co Thuc Su Thay The Man Hinh May Tinh'),
                'thumbnail' => 'https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?w=800&q=80',
                'summary' => 'Sau 18 tháng kể từ phiên bản đầu tiên, Apple Vision Pro 2 ra mắt với trọng lượng giảm 40%, pin cải thiện và giá rẻ hơn đáng kể. Liệu đây có phải là thời điểm để "spatial computing" thực sự cất cánh?',
                'content' => '<h2>Thiết kế — Nhẹ hơn, Thoải mái hơn</h2>
<p>Điểm chỉ trích lớn nhất của Vision Pro thế hệ đầu là trọng lượng 600g gây mỏi cổ sau 30 phút sử dụng. Vision Pro 2 giải quyết triệt để vấn đề này: trọng lượng giảm xuống còn 380g nhờ vật liệu titanium mới và pin được tích hợp trực tiếp vào headset thay vì dây cáp ngoài.</p>
<p>Đệm mắt được làm lại hoàn toàn với vật liệu silicone y tế, thoáng khí hơn và phù hợp với nhiều hình dạng khuôn mặt khác nhau. Apple cũng thêm lựa chọn dây đeo mới nhẹ hơn 25% cho người dùng có đầu nhỏ hơn.</p>

<h2>Display — Micro-OLED 8K Mỗi Mắt</h2>
<p>Màn hình Micro-OLED mới đạt 8K per eye (so với 4K của thế hệ trước), với mật độ điểm ảnh 4500 PPI — đủ để văn bản trông sắc nét như giấy in. Độ trễ đầu vào giảm xuống dưới 8ms, hoàn toàn loại bỏ cảm giác say xe khi di chuyển trong không gian ảo.</p>

<h2>visionOS 3 — AI Spatial Computing</h2>
<p>visionOS 3 tích hợp sâu với Apple Intelligence: bạn có thể nhìn vào một văn bản trên màn hình thực (bàn làm việc, sách) và yêu cầu AI tóm tắt, dịch hoặc tra cứu thông tin liên quan — hoàn toàn hands-free bằng eye tracking và lệnh thoại.</p>
<p>FaceTime Spatial mới cho phép avatar 3D của người tham gia cuộc gọi ngồi trực tiếp trong phòng của bạn — trải nghiệm gần nhất với "họp mặt thực tế" trong thời đại remote work.</p>

<h2>Kết luận</h2>
<p>Vision Pro 2 không còn là sản phẩm "thử nghiệm công nghệ" nữa. Với mức giá 2.499 USD (giảm từ 3.499 USD), nó đang tiến vào ngưỡng "premium professional tool" — tương đương MacBook Pro cao cấp. Nếu bạn làm việc trong lĩnh vực thiết kế, kiến trúc hoặc y tế, đây là khoản đầu tư đáng cân nhắc nghiêm túc.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(2)->subHours(4),
                'views' => 987,
                'meta_title' => 'Apple Vision Pro 2 Review 2026 — Có Đáng Mua Không? | OmniCommerce',
                'meta_description' => 'Đánh giá Apple Vision Pro 2: nhẹ hơn 40%, màn hình 8K per eye, visionOS 3 AI. Phân tích chi tiết có nên mua ở mức giá 2.499 USD.',
            ],
            [
                'title' => 'Google Pixel 10 Pro vs iPhone 17 Pro: Camera Flagship Nào Chụp Đêm Tốt Hơn?',
                'slug' => Str::slug('Google Pixel 10 Pro vs iPhone 17 Pro Camera Flagship Nao Chup Dem Tot Hon'),
                'thumbnail' => 'https://images.unsplash.com/photo-1533228100845-08145b01de14?w=800&q=80',
                'summary' => 'Cuộc chiến camera smartphone 2026 đã đến đỉnh điểm khi Google Pixel 10 Pro và iPhone 17 Pro đều tuyên bố là "camera tốt nhất thế giới". Chúng tôi thực hiện 200 bộ ảnh trong 10 điều kiện ánh sáng khác nhau để tìm ra câu trả lời dứt khoát.',
                'content' => '<h2>Phương pháp kiểm tra</h2>
<p>Chúng tôi chụp cùng một cảnh vật với cả hai máy ở 10 điều kiện: ngoài trời ban ngày, trong nhà đèn huỳnh quang, ánh nến, đèn đường đêm phố, đêm tối hoàn toàn (ISO cao), portrait studio, macro, góc rộng, zoom 5x và zoom 10x. Mỗi điều kiện chụp 20 ảnh và chọn 10 tốt nhất.</p>

<h2>Ban ngày — Hòa</h2>
<p>Cả hai máy đều xuất sắc trong điều kiện ánh sáng tốt. iPhone 17 Pro cho màu sắc ấm hơn, trung thực với mắt người hơn. Pixel 10 Pro cho dynamic range rộng hơn đôi chút, chi tiết vùng bóng tốt hơn. Đây là cuộc hòa thực sự — tùy thuộc vào aesthetic mỗi người.</p>

<h2>Chụp đêm — Pixel thắng rõ ràng</h2>
<p>Google Tensor G5 chip có NPU được tối ưu hóa đặc biệt cho Night Sight. Trong điều kiện ánh sáng cực thấp (dưới 1 lux), Pixel 10 Pro tạo ra ảnh sáng hơn, ít noise hơn và giữ được nhiều chi tiết hơn iPhone 17 Pro đến 35%.</p>
<p>Tuy nhiên, iPhone 17 Pro phục thù ở Portrait đêm: thuật toán phân tách background/foreground của Apple chính xác hơn Google, tạo ra bokeh tự nhiên hơn ở điều kiện thiếu sáng.</p>

<h2>Video — iPhone thắng</h2>
<p>Đây là điểm mạnh không thể tranh cãi của iPhone: Log profile, Cinematic Mode 4K 120fps và khả năng chuyển focal length mượt mà giữa các camera khiến iPhone 17 Pro vẫn là vua quay video. Pixel 10 Pro có Video Boost tốt hơn thế hệ trước nhưng vẫn tụt hậu so với Apple trong tác vụ professional video.</p>

<h2>Kết luận</h2>
<p><strong>Chụp ảnh thuần túy</strong>: Pixel 10 Pro thắng (đặc biệt chụp đêm).<br><strong>Quay video chuyên nghiệp</strong>: iPhone 17 Pro thắng.<br><strong>Tổng thể</strong>: Hòa — phụ thuộc hoàn toàn vào mục đích sử dụng chính của bạn.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(4)->subHours(7),
                'views' => 1156,
                'meta_title' => 'Google Pixel 10 Pro vs iPhone 17 Pro: Camera Nào Chụp Đêm Tốt Hơn? | OmniCommerce',
                'meta_description' => 'So sánh camera Pixel 10 Pro và iPhone 17 Pro: 200 bộ ảnh thực tế, 10 điều kiện ánh sáng. Ai thắng trong cuộc chiến flagship camera 2026?',
            ],
            [
                'title' => 'Review Laptop Gaming ASUS ROG Zephyrus G16 2026: RTX 5080 Laptop Mỏng Nhất Thế Giới',
                'slug' => Str::slug('Review Laptop Gaming ASUS ROG Zephyrus G16 2026 RTX 5080 Laptop Mong Nhat The Gioi'),
                'thumbnail' => 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
                'summary' => 'ASUS ROG Zephyrus G16 2026 mang RTX 5080 Laptop GPU vào thân máy chỉ dày 16.9mm — mỏng hơn nhiều MacBook Pro 16. Đây là cỗ máy gaming mỏng nhất với GPU cao cấp nhất hiện tại, nhưng liệu nhiệt độ và pin có là vấn đề?',
                'content' => '<h2>Thiết kế — Mỏng đến Kinh Ngạc</h2>
<p>16.9mm độ dày là con số khó tin cho một laptop trang bị RTX 5080 Laptop GPU. ASUS đạt được điều này nhờ hệ thống tản nhiệt Tri-Fan Technology với 3 quạt và 2 buồng hơi tổng diện tích 36.000mm² — lớn hơn 60% so với thế hệ trước.</p>
<p>Vỏ máy được làm từ nhôm CNC nguyên khối với kết cấu "Slash Lighting" LED RGB ARGB chạy dọc hai bên — thiết kế futuristic mang đúng DNA ROG nhưng không quá phô trương để có thể dùng trong văn phòng.</p>

<h2>Hiệu năng — RTX 5080 Laptop GPU</h2>
<p>Với TGP 175W (có thể boost lên 200W với MUX Switch bật), RTX 5080 Laptop trong G16 2026 đạt:</p>
<ul>
  <li>Cyberpunk 2077 Ultra 1440p: 127 FPS trung bình</li>
  <li>Alan Wake 2 4K Ultra: 89 FPS với DLSS 4 Multi Frame Generation</li>
  <li>Blender BMW render: 2 phút 14 giây (so với 4 phút 8 giây của RTX 4080 Laptop)</li>
</ul>
<p>AMD Ryzen AI 9 HX 3D 2026 với 3D V-Cache 128MB mang lại hiệu năng CPU đặc biệt tốt cho gaming — latency thấp và frame rate ổn định hơn ở các tựa game CPU-limited.</p>

<h2>Màn hình — OLED 240Hz 2560×1600</h2>
<p>Tấm OLED ROG Nebula 16 inch đạt độ sáng 1000 nits, cover 100% DCI-P3 và có thể chạy ở 240Hz. Đây là màn hình laptop tốt nhất cho gaming — màu sắc chính xác, black level tuyệt đối và không ghosting nhờ response time 0.2ms.</p>

<h2>Pin & Nhiệt</h2>
<p>Pin 90Wh: khoảng 4.5 giờ trong điều kiện văn phòng thông thường — chấp nhận được cho laptop gaming tầm này. Nhiệt độ: GPU peak 78°C, CPU peak 89°C trong stress test — kiểm soát tốt cho form factor này. Quạt chạy ở 52dB khi full load — khá ồn, nên dùng tai nghe khi gaming.</p>

<h2>Giá & Kết luận</h2>
<p>Giá khoảng 65–70 triệu đồng tại Việt Nam. Đây là laptop gaming mỏng nhất với hiệu năng cao nhất hiện tại. Nếu bạn cần máy vừa gaming vừa mang đi làm được, G16 2026 là lựa chọn tốt nhất trên thị trường. Điểm trừ duy nhất: pin ngắn và quạt ồn khi full load.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(6)->subHours(2),
                'views' => 743,
                'meta_title' => 'Review ASUS ROG Zephyrus G16 2026 RTX 5080: Laptop Gaming Mỏng Nhất | OmniCommerce',
                'meta_description' => 'Đánh giá chi tiết ASUS ROG Zephyrus G16 2026 với RTX 5080 Laptop, OLED 240Hz, dày 16.9mm. Benchmark gaming thực tế, nhiệt độ và đánh giá tổng thể.',
            ],
            [
                'title' => 'Smartwatch 2026: Galaxy Watch 8 Ultra vs Apple Watch Series 11 — Đâu Là Lựa Chọn Tốt Nhất?',
                'slug' => Str::slug('Smartwatch 2026 Galaxy Watch 8 Ultra vs Apple Watch Series 11 Dau La Lua Chon Tot Nhat'),
                'thumbnail' => 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
                'summary' => 'Đồng hồ thông minh 2026 đã vượt qua ranh giới "phụ kiện" để trở thành thiết bị y tế thực thụ. Galaxy Watch 8 Ultra và Apple Watch Series 11 đều có thể đo đường huyết không xâm lấn — nhưng ai làm tốt hơn?',
                'content' => '<h2>Tính năng Y tế — Điểm Đột Phá 2026</h2>
<p>Cả hai đồng hồ đều ra mắt với tính năng đo đường huyết không xâm lấn (non-invasive glucose monitoring) — tính năng được chờ đợi hàng chục năm trong ngành y tế di động. Sử dụng sensor quang học đa bước sóng và thuật toán AI, chúng ước tính nồng độ glucose trong máu với độ chính xác đủ để cảnh báo tình trạng hypo/hyperglycemia.</p>
<p><strong>Lưu ý quan trọng</strong>: Đây là tính năng hỗ trợ, không thay thế máy đo đường huyết y tế. FDA và Bộ Y tế Việt Nam phân loại đây là "wellness monitoring" chứ không phải thiết bị y tế chẩn đoán.</p>

<h2>Galaxy Watch 8 Ultra</h2>
<p>Samsung trang bị khung titanium grade 4, pin 600mAh (kéo dài 72 giờ ở chế độ thường) và màn hình AMOLED 1.5 inch sáng 3000 nits. Lợi thế lớn: tích hợp sâu với hệ sinh thái Android và Samsung Health có 8 năm dữ liệu sức khỏe làm nền để AI phân tích.</p>
<p>Galaxy AI trên Watch 8 Ultra có thể phân tích xu hướng sức khỏe 30 ngày và đưa ra cảnh báo sớm về các chỉ số bất thường, đồng thời gợi ý lịch tập phù hợp.</p>

<h2>Apple Watch Series 11</h2>
<p>Apple Watch Series 11 tiếp tục dẫn đầu về accuracy trong theo dõi sức khỏe — nhiều nghiên cứu độc lập xếp Apple Watch là đồng hồ thông minh chính xác nhất cho ECG, SpO2 và heart rate variability. watchOS 12 với AI health insights mới phân tích sleep pattern và đưa ra khuyến nghị cá nhân hóa.</p>
<p>Hạn chế: chỉ tương thích iPhone, pin 36 giờ ngắn hơn Galaxy Watch 8 Ultra đáng kể.</p>

<h2>So sánh tổng quan</h2>
<p>Chọn <strong>Galaxy Watch 8 Ultra</strong> nếu: bạn dùng Android, cần pin dài và muốn đồng hồ thể thao bền bỉ.<br>Chọn <strong>Apple Watch Series 11</strong> nếu: bạn dùng iPhone và ưu tiên accuracy y tế cao nhất.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(8)->subHours(5),
                'views' => 621,
                'meta_title' => 'Galaxy Watch 8 Ultra vs Apple Watch Series 11: Smartwatch Nào Tốt Hơn 2026?',
                'meta_description' => 'So sánh Galaxy Watch 8 Ultra và Apple Watch Series 11: đo đường huyết, pin, thiết kế và tính năng AI health. Lựa chọn nào phù hợp với bạn?',
            ],
            [
                'title' => '5 Lý Do Tại Sao SSD Vẫn Quan Trọng Hơn RAM Khi Nâng Cấp PC/Laptop Năm 2026',
                'slug' => Str::slug('5 Ly Do SSD Van Quan Trong Hon RAM Khi Nang Cap PC Laptop Nam 2026'),
                'thumbnail' => 'https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?w=800&q=80',
                'summary' => 'Nhiều người vẫn nghĩ tăng RAM từ 16GB lên 32GB là nâng cấp đáng nhất. Thực tế? Thay SSD SATA sang NVMe Gen 4 thường tạo ra sự khác biệt lớn hơn trong trải nghiệm hàng ngày. Đây là 5 lý do được chứng minh bằng benchmark thực tế.',
                'content' => '<h2>1. Thời gian khởi động Windows giảm 3–5 lần</h2>
<p>Benchmark thực tế: HDD 7200RPM khởi động Windows 11 trong 45–60 giây. SSD SATA: 15–20 giây. NVMe Gen 4 PCIe: 8–12 giây. Tăng RAM từ 16GB lên 32GB không thay đổi thời gian boot dù chỉ 1 giây.</p>
<p>Đây là trải nghiệm bạn cảm nhận <em>ngay lập tức</em> mỗi ngày, không cần benchmark để nhận ra.</p>

<h2>2. Load time ứng dụng giảm 60–80%</h2>
<p>Adobe Photoshop 2026 mở trong 3.2 giây trên NVMe Gen 4 so với 18 giây trên HDD. Chrome với 20 tab mở sau restart: 4.1 giây vs 22 giây. RAM nhiều hơn chỉ giúp khi bạn đã đạt đến giới hạn (Windows swap file) — với 16GB RAM, hầu hết tác vụ văn phòng không chạm đến ngưỡng đó.</p>

<h2>3. NVMe Gen 5 — Sequential Read 14.000 MB/s</h2>
<p>Samsung 990 Pro Gen 5 và WD Black SN850X Gen 5 đạt sequential read 14.000 MB/s — nhanh gấp 7 lần Gen 4 và gấp 30 lần SATA SSD. Với video editors làm việc với footage 8K RAW hay developers build project lớn, tốc độ này tạo ra sự khác biệt đo được bằng giờ mỗi ngày.</p>

<h2>4. Random Read/Write — Bottleneck thực sự của Windows</h2>
<p>Windows thực hiện hàng triệu random I/O operations mỗi ngày cho registry, temp files, page file. HDD có random read 0.5–1 MB/s; NVMe Gen 4 đạt 70–80 MB/s random read — cải thiện 80–160 lần ở bottleneck thực sự của hệ điều hành.</p>

<h2>5. Giá/hiệu năng tốt hơn RAM</h2>
<p>NVMe Gen 4 1TB: khoảng 800.000–1.200.000đ. RAM 16GB DDR5 (nâng từ 16 lên 32GB): 1.500.000–2.000.000đ. Nếu bạn đang dùng HDD hoặc SATA SSD cũ, 1TB NVMe Gen 4 sẽ tạo ra sự khác biệt lớn hơn nhiều so với thêm 16GB RAM với chi phí thấp hơn.</p>

<h2>Khi nào nên nâng RAM?</h2>
<p>Nâng RAM khi: task manager cho thấy RAM usage thường xuyên trên 85%, bạn chạy nhiều VM, làm video editing với footage 4K+ hoặc lập trình với nhiều container Docker. Nếu không ở tình huống đó, SSD vẫn là ưu tiên số 1.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(10)->subHours(3),
                'views' => 445,
                'meta_title' => '5 Lý Do SSD Quan Trọng Hơn RAM Khi Nâng Cấp PC 2026 | OmniCommerce',
                'meta_description' => 'SSD NVMe Gen 4/5 hay thêm RAM? Benchmark thực tế chứng minh tại sao nâng cấp SSD tạo ra sự khác biệt lớn hơn trong 95% trường hợp sử dụng hàng ngày.',
            ],
            [
                'title' => 'Hướng Dẫn Thiết Lập Home Office Chuẩn Ergonomic Cho Dân IT — Dưới 15 Triệu Đồng',
                'slug' => Str::slug('Huong Dan Thiet Lap Home Office Chuan Ergonomic Cho Dan IT Duoi 15 Trieu Dong'),
                'thumbnail' => 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&q=80',
                'summary' => 'Làm việc từ xa 8 tiếng/ngày với setup kém ergonomic là con đường nhanh nhất đến đau lưng, mỏi mắt và hội chứng ống cổ tay. Hướng dẫn này giúp bạn xây dựng home office chuẩn nhân trắc học với ngân sách thực tế dưới 15 triệu đồng.',
                'content' => '<h2>1. Màn hình — Ưu tiên số 1</h2>
<p>Màn hình đặt cách mắt 50–70cm, đỉnh màn hình ngang tầm mắt hoặc thấp hơn 5–10cm. Kích thước tối thiểu 27 inch cho công việc văn phòng; 32 inch cho design/video editing.</p>
<p><strong>Gợi ý ngân sách</strong>: LG 27GP850-B 27 inch QHD 165Hz (khoảng 5.5 triệu) — tốt cho cả coding, design và giải trí. Tránh Full HD trên màn hình 27 inch — pixel density quá thấp gây mỏi mắt.</p>

<h2>2. Ghế — Đầu tư quan trọng nhất</h2>
<p>Ghế ergonomic chuẩn phải có: lưng tựa điều chỉnh được (hỗ trợ lumbar), tay vịn 4D (lên/xuống, vào/ra, xoay), đệm ngồi có thể điều chỉnh độ nghiêng và độ sâu.</p>
<p><strong>Tầm 3–5 triệu</strong>: Sihoo Doro S300, ErgoTune Supreme V3 (nhập). Cần thử ngồi ít nhất 30 phút trước khi mua — ergonomic là rất cá nhân.</p>

<h2>3. Bàn — Chiều cao là tất cả</h2>
<p>Chiều cao bàn chuẩn: khuỷu tay tạo góc 90–110° khi đặt trên bàn, vai thả lỏng. Với người Việt Nam chiều cao trung bình, đó thường là 70–75cm. Bàn nâng hạ điều chỉnh điện (standing desk) là đầu tư lý tưởng nhưng đắt hơn — tầm 4–6 triệu cho loại tốt.</p>

<h2>4. Bàn phím & Chuột Ergonomic</h2>
<p><strong>Bàn phím</strong>: Logitech MX Keys hoặc Keychron K3 thấp profile giảm căng cổ tay. Đặt bàn phím ở vị trí tay không phải nâng vai.</p>
<p><strong>Chuột</strong>: Chuột dạng vertical (Logitech MX Vertical, ~1.2 triệu) giúp tư thế bàn tay tự nhiên hơn, giảm nguy cơ hội chứng ống cổ tay đến 54% theo nghiên cứu của Cornell University.</p>

<h2>5. Ánh sáng — Yếu tố bị bỏ quên nhất</h2>
<p>Ánh sáng phòng làm việc phải đủ sáng (300–500 lux cho văn phòng) nhưng không gây lóa. Đặt màn hình vuông góc với cửa sổ — không đối mặt hay quay lưng lại cửa sổ. Đèn bàn với color temperature 4000–5000K (white neutral) giảm mỏi mắt tốt hơn đèn vàng (2700K) khi làm việc ban ngày.</p>

<h2>Budget Breakdown — Dưới 15 Triệu</h2>
<p>Màn hình 27" QHD: 5.5 triệu | Ghế ergonomic: 4.5 triệu | Bàn làm việc: 2 triệu | Bàn phím + chuột: 2 triệu | Đèn bàn LED: 500K | Laptop stand + hub: 500K. <strong>Tổng: ~15 triệu đồng</strong> cho setup đủ để làm việc hiệu quả 8 tiếng/ngày không đau lưng.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(12)->subHours(6),
                'views' => 389,
                'meta_title' => 'Thiết Lập Home Office Ergonomic Cho Dân IT Dưới 15 Triệu 2026 | OmniCommerce',
                'meta_description' => 'Hướng dẫn xây dựng home office chuẩn ergonomic: màn hình, ghế, bàn, ánh sáng. Budget breakdown thực tế dưới 15 triệu đồng để làm việc 8h/ngày không đau lưng.',
            ],
        ];

        foreach ($posts as $post) {
            Post::updateOrCreate(
                ['slug' => $post['slug']],
                array_merge($post, [
                    'created_at' => now(),
                    'updated_at' => now(),
                ])
            );
        }

        $this->command->info('✅ PostPaginationSeeder: 6 bài viết bổ sung đã được thêm — tổng cộng 11 bài, kích hoạt phân trang!');
    }
}
