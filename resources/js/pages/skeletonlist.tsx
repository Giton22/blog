
import { Skeleton } from '@/components/ui/skeleton';

interface SkeletonListProps {
    count: number;
    containerClassName?: string;
    itemClassName?: string;
    listItemClassName?: string;
}

const SkeletonList: React.FC<SkeletonListProps> = ({
    count,
    containerClassName = "flex-1",
    itemClassName = "h-6 w-full",
    listItemClassName = "mb-2",
}) => (
    <ul className={containerClassName}>
        {Array.from({ length: count }, (_, index) => (
            <li key={index} className={listItemClassName}>
                <Skeleton className={itemClassName} />
            </li>
        ))}
    </ul>
);

export default SkeletonList;