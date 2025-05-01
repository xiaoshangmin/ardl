import { getSavedLocale } from './settings'; // 假设有一个函数可以获取保存的语言设置

const defaultLocale = getSavedLocale() || 'en'; // 使用保存的语言设置，默认值为 'en'

export const LocaleProvider = ({ children }) => {
    const [locale, setLocale] = useState(defaultLocale);
    // ...
} 