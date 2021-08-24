const instrument = +process.env.JAMULUS_CLIENT_INSTRUMENT || 24;
const name = process.env.JAMULUS_CLIENT_NAME || "";

console.log(`<client>
 <language>en</language>
 <name_base64>${Buffer.from(name).toString("base64")}</name_base64>
 <instrument>${instrument}</instrument>
 <country>0</country>
 <autojitbuf>0</autojitbuf>
 <jitbuf>20</jitbuf>
 <jitbufserver>20</jitbufserver>
 <audiochannels>2</audiochannels>
 <audioquality>2</audioquality>
</client>`);
