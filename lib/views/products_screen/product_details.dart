import '../../const/const.dart';
import '../widgets/normal_text.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final images = data['p_imgs'] is List ? data['p_imgs'] as List : const [];
    final colors = data['p_colors'] is List
        ? data['p_colors'] as List
        : const [];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: darkGrey),
        ),
        title: boldText(
          text: data['p_name']?.toString() ?? 'Product',
          color: fontGrey,
          size: 16.0,
        ),
      ),
      body: ListView(
        children: [
          if (images.isEmpty)
            const SizedBox(
              height: 260,
              child: Center(child: Icon(Icons.image_not_supported, size: 48)),
            )
          else
            VxSwiper.builder(
              autoPlay: images.length > 1,
              height: 350,
              itemCount: images.length,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              itemBuilder: (context, index) => Image.network(
                images[index].toString(),
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image_outlined, size: 48),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(
                  text: data['p_name']?.toString() ?? 'Unnamed product',
                  color: fontGrey,
                  size: 18.0,
                ),
                10.heightBox,
                normalText(
                  text:
                      '${data['p_category'] ?? ''} • ${data['p_subcategory'] ?? ''}',
                  color: darkGrey,
                ),
                10.heightBox,
                VxRating(
                  isSelectable: false,
                  value:
                      double.tryParse(data['p_rating']?.toString() ?? '') ?? 0,
                  onRatingUpdate: (value) {},
                  normalColor: textfieldGrey,
                  selectionColor: golden,
                  count: 5,
                  maxRating: 5,
                  size: 25,
                ),
                10.heightBox,
                boldText(
                  text: '\$${data['p_price'] ?? 0}',
                  color: red,
                  size: 18.0,
                ),
                20.heightBox,
                if (colors.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: colors
                        .map(
                          (color) => Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Color(
                                int.tryParse(color.toString()) ?? 0xFF111827,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                16.heightBox,
                boldText(
                  text: 'Quantity: ${data['p_quantity'] ?? 0}',
                  color: fontGrey,
                ),
                20.heightBox,
                boldText(text: 'Description', color: fontGrey),
                8.heightBox,
                normalText(
                  text: data['p_desc']?.toString() ?? 'No description',
                  color: darkGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
